1. Tabela Cliente
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo ENUM('PF', 'PJ') NOT NULL,
    cpf CHAR(11) UNIQUE,
    cnpj CHAR(14) UNIQUE,
    email VARCHAR(100),
    telefone VARCHAR(20),
    CHECK (
        (tipo = 'PF' AND cpf IS NOT NULL AND cnpj IS NULL) OR
        (tipo = 'PJ' AND cnpj IS NOT NULL AND cpf IS NULL)
    )
);

2. Tabela Forma de Pagamento
CREATE TABLE FormaPagamento (
    id_forma_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

3. Tabela associativa Cliente_FormaPagamento (N:N)
CREATE TABLE Cliente_FormaPagamento (
    id_cliente INT,
    id_forma_pagamento INT,
    PRIMARY KEY (id_cliente, id_forma_pagamento),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_forma_pagamento) REFERENCES FormaPagamento(id_forma_pagamento)
);

4. Tabela Pedido
CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    status_entrega ENUM('Pendente', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Pendente',
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

5. Tabela Entrega
CREATE TABLE Entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT UNIQUE,
    status ENUM('Pendente', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Pendente',
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

Instãncias:

1-Cliente (2 PFs e 2 PJs):
INSERT INTO Cliente (nome, tipo, cpf, cnpj, email, telefone)
VALUES 
('João Silva', 'PF', '12345678901', NULL, 'joao@gmail.com', '(11) 99999-0001'),
('Maria Souza', 'PF', '98765432100', NULL, 'maria@hotmail.com', '(21) 98888-0002'),
('Auto Center Ltda', 'PJ', NULL, '11222333444455', 'contato@autocenter.com.br', '(31) 97777-0003'),
('Peças Rápidas ME', 'PJ', NULL, '55667788990011', 'vendas@pecasrapidas.com.br', '(41) 96666-0004');

2-FormaPagamento
INSERT INTO FormaPagamento (descricao)
VALUES 
('Dinheiro'),
('Cartão de Crédito'),
('Cartão de Débito'),
('Pix'),
('Boleto');

3. Cliente_FormaPagamento
INSERT INTO Cliente_FormaPagamento (id_cliente, id_forma_pagamento)
VALUES
(1, 1),  -- João Silva usa Dinheiro
(1, 4),  -- João Silva usa Pix
(2, 2),  -- Maria usa Cartão de Crédito
(3, 5),  -- Auto Center usa Boleto
(4, 3),  -- Peças Rápidas usa Cartão de Débito
(4, 4);  -- Peças Rápidas também usa Pix

4. Pedido
INSERT INTO Pedido (id_cliente, total, status_entrega, codigo_rastreio)
VALUES
(1, 150.00, 'Pendente', 'BR1234567890'),
(2, 320.50, 'Enviado', 'BR0987654321'),
(3, 899.99, 'Entregue', 'BR5678901234'),
(4, 450.00, 'Cancelado', NULL);

5. Entrega
INSERT INTO Entrega (id_pedido, status, codigo_rastreio)
VALUES
(1, 'Pendente', 'BR1234567890'),
(2, 'Enviado', 'BR0987654321'),
(3, 'Entregue', 'BR5678901234'),
(4, 'Cancelado', NULL);

