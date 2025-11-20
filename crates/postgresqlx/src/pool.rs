use crate::{PostgreSQLConfig, PostgreSQLError, Result};
use sqlx::PgPool;
use std::sync::Arc;
use tokio::sync::OnceCell;

static GLOBAL_POOL: OnceCell<Arc<PgPool>> = OnceCell::const_new();

/// PostgreSQL connection pool wrapper
#[derive(Clone)]
pub struct PostgreSQLPool {
    pool: Arc<PgPool>,
}

impl PostgreSQLPool {
    /// Initialize the global PostgreSQL connection pool
    pub async fn init(config: &PostgreSQLConfig) -> Result<Self> {
        let pool = config.create_pool().await?;
        let pool_arc = Arc::new(pool);
        
        GLOBAL_POOL
            .set(pool_arc.clone())
            .map_err(|_| PostgreSQLError::ConfigurationError("Pool already initialized".to_string()))?;

        Ok(Self { pool: pool_arc })
    }

    /// Get the global PostgreSQL connection pool
    pub fn get() -> Result<Self> {
        let pool = GLOBAL_POOL
            .get()
            .ok_or_else(|| PostgreSQLError::ConfigurationError("Pool not initialized. Call init() first.".to_string()))?;
        
        Ok(Self { pool: pool.clone() })
    }

    /// Get the underlying PgPool
    pub fn inner(&self) -> &PgPool {
        &self.pool
    }

    /// Execute a query and return the number of affected rows
    pub async fn execute(&self, query: &str) -> Result<u64> {
        sqlx::query(query)
            .execute(self.inner())
            .await
            .map_err(|e| PostgreSQLError::QueryError(e.to_string()))
            .map(|r| r.rows_affected())
    }

    /// Check if the connection pool is healthy
    pub async fn health_check(&self) -> Result<bool> {
        sqlx::query("SELECT 1")
            .execute(self.inner())
            .await
            .map_err(|e| PostgreSQLError::QueryError(e.to_string()))
            .map(|_| true)
    }
}

