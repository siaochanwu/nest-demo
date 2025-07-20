-- 建立資料庫 (如果不存在)
CREATE DATABASE nest_demo;

-- 切換到 nest_demo 資料庫
\c nest_demo;

-- 如果你想使用 schema，可以建立並設定
-- CREATE SCHEMA IF NOT EXISTS nest_demo;
-- SET search_path TO nest_demo;

-- 建立 users 資料表
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 建立 roles 資料表
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 建立 user_roles 中間表 (多對多關係)
CREATE TABLE IF NOT EXISTS user_roles (
    id SERIAL PRIMARY KEY,
    "userId" INTEGER NOT NULL,
    "roleId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("userId") REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY ("roleId") REFERENCES roles(id) ON DELETE CASCADE,
    UNIQUE("userId", "roleId")
);

-- 建立索引
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON user_roles("userId");
CREATE INDEX IF NOT EXISTS idx_user_roles_role_id ON user_roles("roleId");
CREATE INDEX IF NOT EXISTS idx_roles_name ON roles(name);

-- 建立更新時間戳記的函數 (如果不存在)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."updatedAt" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 建立觸發器
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_roles_updated_at ON roles;
CREATE TRIGGER update_roles_updated_at 
    BEFORE UPDATE ON roles 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 插入預設角色資料
INSERT INTO roles (name, description) VALUES
('admin', 'Administrator with full access'),
('user', 'Regular user with limited access'),
('moderator', 'Moderator with content management access')
ON CONFLICT (name) DO NOTHING;

-- 插入測試用戶
INSERT INTO users (username, name, email, mobile, password) VALUES
('john', 'John', 'john@example.com', '1234567890', 'password'),
('wow', 'Wow User', 'wow@example.com', '9876543210', 'password')
ON CONFLICT (username) DO NOTHING;

-- 插入用戶角色關係
INSERT INTO user_roles ("userId", "roleId") 
SELECT u.id, r.id 
FROM users u, roles r 
WHERE u.username = 'john' AND r.name IN ('admin', 'user')
ON CONFLICT ("userId", "roleId") DO NOTHING;

INSERT INTO user_roles ("userId", "roleId") 
SELECT u.id, r.id 
FROM users u, roles r 
WHERE u.username = 'wow' AND r.name = 'user'
ON CONFLICT ("userId", "roleId") DO NOTHING;

-- 建立客戶表
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    address VARCHAR(500),
    "birth_date" DATE,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    notes TEXT,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 建立服務表
CREATE TABLE IF NOT EXISTS services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration INTEGER NOT NULL, -- 服務時長（分鐘）
    category VARCHAR(100),
    "is_active" BOOLEAN DEFAULT TRUE,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 建立預約單表
CREATE TABLE IF NOT EXISTS appointments (
    id SERIAL PRIMARY KEY,
    "appointmentDateTime" TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show')),
    notes TEXT,
    "totalPrice" DECIMAL(10, 2),
    "customerId" INTEGER NOT NULL,
    "serviceId" INTEGER NOT NULL,
    "staffId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- 外鍵約束
    CONSTRAINT fk_appointments_customer FOREIGN KEY ("customerId") REFERENCES customers(id) ON DELETE CASCADE,
    CONSTRAINT fk_appointments_service FOREIGN KEY ("serviceId") REFERENCES services(id) ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_staff FOREIGN KEY ("staffId") REFERENCES users(id) ON DELETE RESTRICT
);

-- 建立客戶表觸發器
DROP TRIGGER IF EXISTS update_customers_updated_at ON customers;
CREATE TRIGGER update_customers_updated_at 
    BEFORE UPDATE ON customers 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 建立服務表觸發器
DROP TRIGGER IF EXISTS update_services_updated_at ON services;
CREATE TRIGGER update_services_updated_at 
    BEFORE UPDATE ON services 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 建立預約單表觸發器
DROP TRIGGER IF EXISTS update_appointments_updated_at ON appointments;
CREATE TRIGGER update_appointments_updated_at 
    BEFORE UPDATE ON appointments 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 建立客戶表索引
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_customers_mobile ON customers(mobile);
CREATE INDEX IF NOT EXISTS idx_customers_name ON customers(name);

-- 建立服務表索引
CREATE INDEX IF NOT EXISTS idx_services_name ON services(name);
CREATE INDEX IF NOT EXISTS idx_services_category ON services(category);
CREATE INDEX IF NOT EXISTS idx_services_is_active ON services("isActive");
CREATE INDEX IF NOT EXISTS idx_services_price ON services(price);

-- 建立預約單表索引
CREATE INDEX IF NOT EXISTS idx_appointments_customer_id ON appointments("customerId");
CREATE INDEX IF NOT EXISTS idx_appointments_service_id ON appointments("serviceId");
CREATE INDEX IF NOT EXISTS idx_appointments_staff_id ON appointments("staffId");
CREATE INDEX IF NOT EXISTS idx_appointments_status ON appointments(status);
CREATE INDEX IF NOT EXISTS idx_appointments_datetime ON appointments("appointmentDateTime");
CREATE INDEX IF NOT EXISTS idx_appointments_staff_datetime ON appointments("staffId", "appointmentDateTime");
CREATE INDEX IF NOT EXISTS idx_appointments_customer_datetime ON appointments("customerId", "appointmentDateTime");

-- 插入測試客戶資料
INSERT INTO customers (name, email, mobile, address, "birth_date", gender, notes) VALUES
('張小明', 'ming@example.com', '0912345678', '台北市信義區信義路五段7號', '1990-05-15', 'male', 'VIP客戶'),
('李美麗', 'meili@example.com', '0987654321', '台中市西屯區台灣大道三段99號', '1985-12-20', 'female', '對價格敏感'),
('王大華', 'dahua@example.com', '0956781234', '高雄市前金區中正四路211號', '1992-03-10', 'male', '喜歡預約週末時段')
ON CONFLICT (email) DO NOTHING;

-- 插入測試服務資料
INSERT INTO services (name, description, price, duration, category, "is_active") VALUES
('基礎剪髮', '專業髮型設計師提供的基礎剪髮服務', 800.00, 60, '美髮', TRUE),
('洗剪吹造型', '包含洗髮、剪髮、吹整造型的完整服務', 1500.00, 90, '美髮', TRUE),
('染髮服務', '使用進口染劑的專業染髮服務', 2500.00, 180, '美髮', TRUE),
('燙髮服務', '各式燙髮造型服務', 3000.00, 240, '美髮', TRUE),
('深層護髮', '頭皮與髮絲的深層護理', 1200.00, 75, '護髮', TRUE),
('頭皮按摩', '舒壓頭皮按摩服務', 600.00, 30, '護髮', TRUE)
ON CONFLICT DO NOTHING;

-- 查詢確認資料
SELECT 
    u.id,
    u.username,
    u.name,
    u.email,
    ARRAY_AGG(r.name) as roles
FROM users u
LEFT JOIN user_roles ur ON u.id = ur."userId"
LEFT JOIN roles r ON ur."roleId" = r.id
GROUP BY u.id, u.username, u.name, u.email
ORDER BY u.id;

-- 查詢客戶資料
SELECT * FROM customers;

-- 查詢服務資料
SELECT * FROM services;