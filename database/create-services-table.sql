-- 創建服務表
CREATE TABLE IF NOT EXISTS services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration INTEGER NOT NULL COMMENT '服務時長（分鐘）',
    category VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 創建更新時間觸發器
CREATE TRIGGER update_services_updated_at BEFORE UPDATE
    ON services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 創建索引
CREATE INDEX idx_services_name ON services(name);
CREATE INDEX idx_services_category ON services(category);
CREATE INDEX idx_services_is_active ON services(is_active);
CREATE INDEX idx_services_price ON services(price);