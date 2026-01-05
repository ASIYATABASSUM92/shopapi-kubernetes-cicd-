const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// Database connection
const pool = new Pool({
    host: process.env.DB_HOST || 'postgres-service',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'shopdb',
    user: process.env.DB_USER || 'admin',
    password: process.env.DB_PASSWORD || 'admin123'
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ 
        status: 'healthy', 
        service: 'ShopAPI Backend',
        version: process.env.VERSION || '1.0',
        timestamp: new Date().toISOString()
    });
});

// Get all products
app.get('/api/products', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM products ORDER BY id ASC');
        res.json(result.rows);
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: error.message });
    }
});

// Create new product
app.post('/api/products', async (req, res) => {
    try {
        const { name, price, quantity, description, category } = req.body;
        const result = await pool.query(
            'INSERT INTO products (name, price, quantity, description, category) VALUES ($1, $2, $3, $4, $5) RETURNING *',
            [name, price, quantity, description, category]
        );
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: error.message });
    }
});

// Update product
app.put('/api/products/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { name, price, quantity, description, category } = req.body;
        const result = await pool.query(
            'UPDATE products SET name=$1, price=$2, quantity=$3, description=$4, category=$5 WHERE id=$6 RETURNING *',
            [name, price, quantity, description, category, id]
        );
        res.json(result.rows[0]);
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: error.message });
    }
});

// Delete product
app.delete('/api/products/:id', async (req, res) => {
    try {
        const { id } = req.params;
        await pool.query('DELETE FROM products WHERE id = $1', [id]);
        res.json({ message: 'Product deleted successfully', id });
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: error.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 ShopAPI Backend v${process.env.VERSION || '1.0'} running on port ${PORT}`);
    console.log(`📊 Health check: http://localhost:${PORT}/health`);
    console.log(`📦 Products API: http://localhost:${PORT}/api/products`);
});
