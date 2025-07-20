-- 創建預約單表
CREATE TABLE IF NOT EXISTS appointments (
    id SERIAL PRIMARY KEY,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show')),
    notes TEXT,
    total_price DECIMAL(10, 2),
    customer_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 外鍵約束
    CONSTRAINT fk_appointments_customer FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    CONSTRAINT fk_appointments_service FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_staff FOREIGN KEY (staff_id) REFERENCES users(id) ON DELETE RESTRICT
);

-- 創建更新時間觸發器
CREATE TRIGGER update_appointments_updated_at BEFORE UPDATE
    ON appointments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 創建索引
CREATE INDEX idx_appointments_customer_id ON appointments(customer_id);
CREATE INDEX idx_appointments_service_id ON appointments(service_id);
CREATE INDEX idx_appointments_staff_id ON appointments(staff_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_appointments_datetime ON appointments(appointment_date, appointment_time);

-- 創建複合索引用於查詢優化
CREATE INDEX idx_appointments_staff_date ON appointments(staff_id, appointment_date);
CREATE INDEX idx_appointments_customer_date ON appointments(customer_id, appointment_date);