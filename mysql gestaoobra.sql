CREATE SCHEMA Gerenciamento_Obras;

CREATE TABLE Equipe (
    codigo_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome_funcionario VARCHAR(100) NOT NULL,
    funcao VARCHAR(100) NOT NULL,
    responsavel_equipe BOOLEAN DEFAULT FALSE
);

-- Tabela: Fornecedor
CREATE TABLE Fornecedor (
    codigo_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome_fornecedor VARCHAR(100) NOT NULL,
    telefone VARCHAR(100),
    material_fornecido VARCHAR(100),
    tipo_material VARCHAR(100)
);

-- Tabela: Projeto
CREATE TABLE Projeto (
    codigo_projeto INT AUTO_INCREMENT PRIMARY KEY,
    data_inicio DATE NOT NULL,
    data_termino DATE NOT NULL,
    endereco_projeto VARCHAR(100) NOT NULL,
    responsavel_projeto VARCHAR(100) NOT NULL,
    cronograma_andamento TEXT
);

-- Tabela: Obra
CREATE TABLE Obra (
    codigo_obra INT AUTO_INCREMENT PRIMARY KEY,
    nome_obra VARCHAR(100) NOT NULL,
    endereco_obra VARCHAR(100) NOT NULL,
    codigo_equipe_responsavel INT,
    equipamento_utilizado VARCHAR(100),
    manutencao_equipamento TEXT,
    FOREIGN KEY (codigo_equipe_responsavel) REFERENCES Equipe(codigo_funcionario)
);

-- Tabela: Estoque
CREATE TABLE Estoque (
    codigo_estoque INT AUTO_INCREMENT PRIMARY KEY,
    quantidade INT NOT NULL,
    codigo_fornecedor INT,
    responsavel_estoque VARCHAR(100),
    FOREIGN KEY (codigo_fornecedor) REFERENCES Fornecedor(codigo_fornecedor)
);
