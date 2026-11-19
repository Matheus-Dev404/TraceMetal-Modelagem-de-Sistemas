


CREATE TABLE perfil (
    id_perfil INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE setor (
    id_setor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    id_perfil INT NOT NULL,
    id_setor INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil),
    FOREIGN KEY (id_setor) REFERENCES setor(id_setor)
);

CREATE TABLE equipamento (
    id_equipamento INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    tipo VARCHAR(80) NOT NULL,
    numero_serie VARCHAR(80),
    status VARCHAR(30) NOT NULL
);

CREATE TABLE ordem_producao (
    id_ordem INT PRIMARY KEY AUTO_INCREMENT,
    id_equipamento INT NOT NULL,
    codigo_ordem VARCHAR(50) NOT NULL UNIQUE,
    data_abertura DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_previsao DATETIME,
    data_conclusao DATETIME,
    status VARCHAR(30) NOT NULL,
    observacoes TEXT,
    FOREIGN KEY (id_equipamento) REFERENCES equipamento(id_equipamento)
);

CREATE TABLE chapa (
    id_chapa INT PRIMARY KEY AUTO_INCREMENT,
    id_ordem INT NOT NULL,
    codigo_interno VARCHAR(50) NOT NULL UNIQUE,
    material VARCHAR(100),
    espessura DECIMAL(10,2),
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_ordem) REFERENCES ordem_producao(id_ordem)
);

CREATE TABLE datamatrix (
    id_datamatrix INT PRIMARY KEY AUTO_INCREMENT,
    id_chapa INT NOT NULL,

    codigo VARCHAR(100) NOT NULL UNIQUE,
    data_geracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_leitura VARCHAR(30) DEFAULT 'ATIVO',
    FOREIGN KEY (id_chapa) REFERENCES chapa(id_chapa)
);

CREATE TABLE componente (
    id_componente INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(255) NOT NULL,
    lote VARCHAR(50),
    fornecedor VARCHAR(100)
);

CREATE TABLE ordem_componente (
    id_ordem_componente INT PRIMARY KEY AUTO_INCREMENT,
    id_ordem INT NOT NULL,
    id_componente INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (id_ordem) REFERENCES ordem_producao(id_ordem),
    FOREIGN KEY (id_componente) REFERENCES componente(id_componente)
);

CREATE TABLE etapa_producao (
    id_etapa INT PRIMARY KEY AUTO_INCREMENT,
    id_ordem INT NOT NULL,
    id_responsavel INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_inicio DATETIME,
    data_fim DATETIME,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_ordem) REFERENCES ordem_producao(id_ordem),
    FOREIGN KEY (id_responsavel) REFERENCES usuario(id_usuario)
);

CREATE TABLE inspecao_qualidade (
    id_inspecao INT PRIMARY KEY AUTO_INCREMENT,
    id_ordem INT NOT NULL,
    id_inspetor INT NOT NULL,
    resultado VARCHAR(30) NOT NULL,
    observacoes TEXT,
    data_inspecao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ordem) REFERENCES ordem_producao(id_ordem),
    FOREIGN KEY (id_inspetor) REFERENCES usuario(id_usuario)
);

CREATE TABLE nao_conformidade (
    id_nc INT PRIMARY KEY AUTO_INCREMENT,
    id_ordem INT NOT NULL,
    id_inspecao INT,
    descricao TEXT NOT NULL,
    gravidade VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ordem) REFERENCES ordem_producao(id_ordem),
    FOREIGN KEY (id_inspecao) REFERENCES inspecao_qualidade(id_inspecao)
);

CREATE TABLE acao_corretiva (
    id_acao INT PRIMARY KEY AUTO_INCREMENT,
    id_nc INT NOT NULL,
    id_responsavel INT NOT NULL,
    descricao TEXT NOT NULL,

    status VARCHAR(30) NOT NULL,
    data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_conclusao DATETIME,
    FOREIGN KEY (id_nc) REFERENCES nao_conformidade(id_nc),
    FOREIGN KEY (id_responsavel) REFERENCES usuario(id_usuario)
);
