-- 建立 roles 資料表
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 建立 user_roles 中間表 (多對多關係)
CREATE TABLE user_roles (
    id SERIAL PRIMARY KEY,
    "userId" INTEGER NOT NULL,
    "roleId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("userId") REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY ("roleId") REFERENCES roles(id) ON DELETE CASCADE,
    UNIQUE("userId", "roleId")
);

-- 建立索引以提升查詢效能
CREATE INDEX idx_user_roles_user_id ON user_roles("userId");
CREATE INDEX idx_user_roles_role_id ON user_roles("roleId");
CREATE INDEX idx_roles_name ON roles(name);

-- 插入預設角色資料
INSERT INTO roles (name, description) VALUES
('admin', 'Administrator with full access'),
('user', 'Regular user with limited access'),
('moderator', 'Moderator with content management access');

-- 建立更新時間戳記的觸發器 for roles
CREATE TRIGGER update_roles_updated_at 
    BEFORE UPDATE ON roles 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
