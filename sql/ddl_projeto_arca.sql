-- =========================================================
-- DDL - Projeto ARCA
-- Minimundo: sistema de apoio à proteção animal
-- Banco: PostgreSQL
-- =========================================================

-- Para recriar do zero, descomente os DROP TABLE abaixo.
-- A ordem respeita as dependências entre tabelas.

-- DROP TABLE IF EXISTS prontuarios CASCADE;
-- DROP TABLE IF EXISTS gastos CASCADE;
-- DROP TABLE IF EXISTS locais_apoio CASCADE;
-- DROP TABLE IF EXISTS tarefas CASCADE;
-- DROP TABLE IF EXISTS solicitacoes CASCADE;
-- DROP TABLE IF EXISTS status_solicitacao CASCADE;
-- DROP TABLE IF EXISTS tipos_servico CASCADE;
-- DROP TABLE IF EXISTS animais CASCADE;
-- DROP TABLE IF EXISTS racas CASCADE;
-- DROP TABLE IF EXISTS especies CASCADE;
-- DROP TABLE IF EXISTS voluntarios CASCADE;
-- DROP TABLE IF EXISTS ongs CASCADE;
-- DROP TABLE IF EXISTS tutores CASCADE;
-- DROP TABLE IF EXISTS enderecos CASCADE;
-- DROP TABLE IF EXISTS usuarios CASCADE;

-- =========================================================
-- 1. Usuários
-- =========================================================

CREATE TABLE usuarios (
    id_usuario SERIAL,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL,
    cpf_cnpj VARCHAR(18) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL,
    telefone VARCHAR(20),

    CONSTRAINT pk_usuarios PRIMARY KEY (id_usuario),
    CONSTRAINT uk_usuarios_email UNIQUE (email),
    CONSTRAINT uk_usuarios_cpf_cnpj UNIQUE (cpf_cnpj),
    CONSTRAINT ck_usuarios_tipo CHECK (tipo_usuario IN ('TUTOR', 'ONG', 'VOLUNTARIO'))
);

-- =========================================================
-- 2. Endereços
-- =========================================================

CREATE TABLE enderecos (
    id_endereco SERIAL,
    rua VARCHAR(120) NOT NULL,
    numero VARCHAR(20),
    bairro VARCHAR(80) NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep VARCHAR(10),
    complemento VARCHAR(120),

    CONSTRAINT pk_enderecos PRIMARY KEY (id_endereco)
);

-- =========================================================
-- 3. Tutores
-- =========================================================

CREATE TABLE tutores (
    id_tutor SERIAL,
    id_usuario INT NOT NULL,
    id_endereco INT,

    CONSTRAINT pk_tutores PRIMARY KEY (id_tutor),
    CONSTRAINT uk_tutores_usuario UNIQUE (id_usuario),
    CONSTRAINT fk_tutores_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuarios (id_usuario),
    CONSTRAINT fk_tutores_endereco FOREIGN KEY (id_endereco)
        REFERENCES enderecos (id_endereco)
);

-- =========================================================
-- 4. ONGs
-- =========================================================

CREATE TABLE ongs (
    id_ong SERIAL,
    id_usuario INT NOT NULL,
    id_endereco INT,
    nome_fantasia VARCHAR(120) NOT NULL,
    cnpj VARCHAR(18) NOT NULL,
    descricao TEXT,

    CONSTRAINT pk_ongs PRIMARY KEY (id_ong),
    CONSTRAINT uk_ongs_usuario UNIQUE (id_usuario),
    CONSTRAINT uk_ongs_cnpj UNIQUE (cnpj),
    CONSTRAINT fk_ongs_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuarios (id_usuario),
    CONSTRAINT fk_ongs_endereco FOREIGN KEY (id_endereco)
        REFERENCES enderecos (id_endereco)
);

-- =========================================================
-- 5. Voluntários
-- =========================================================

CREATE TABLE voluntarios (
    id_voluntario SERIAL,
    id_usuario INT NOT NULL,
    status_disponibilidade VARCHAR(20) NOT NULL,

    CONSTRAINT pk_voluntarios PRIMARY KEY (id_voluntario),
    CONSTRAINT uk_voluntarios_usuario UNIQUE (id_usuario),
    CONSTRAINT fk_voluntarios_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuarios (id_usuario),
    CONSTRAINT ck_voluntarios_status CHECK (status_disponibilidade IN ('ATIVO', 'OCUPADO', 'INDISPONIVEL'))
);

-- =========================================================
-- 6. Espécies
-- =========================================================

CREATE TABLE especies (
    id_especie SERIAL,
    nome VARCHAR(60) NOT NULL,

    CONSTRAINT pk_especies PRIMARY KEY (id_especie),
    CONSTRAINT uk_especies_nome UNIQUE (nome)
);

-- =========================================================
-- 7. Raças
-- =========================================================

CREATE TABLE racas (
    id_raca SERIAL,
    id_especie INT NOT NULL,
    nome VARCHAR(80) NOT NULL,

    CONSTRAINT pk_racas PRIMARY KEY (id_raca),
    CONSTRAINT fk_racas_especie FOREIGN KEY (id_especie)
        REFERENCES especies (id_especie),
    CONSTRAINT uk_racas_nome_especie UNIQUE (id_especie, nome)
);

-- =========================================================
-- 8. Animais
-- =========================================================

CREATE TABLE animais (
    id_animal SERIAL,
    nome VARCHAR(80) NOT NULL,
    id_especie INT NOT NULL,
    id_raca INT,
    sexo VARCHAR(10) NOT NULL,
    porte VARCHAR(20),
    data_nascimento DATE,
    idade_aproximada VARCHAR(30),
    status_animal VARCHAR(30) NOT NULL,
    observacoes TEXT,
    id_tutor INT,
    id_ong INT,
    id_endereco_resgate INT,
    data_resgate DATE,

    CONSTRAINT pk_animais PRIMARY KEY (id_animal),
    CONSTRAINT fk_animais_especie FOREIGN KEY (id_especie)
        REFERENCES especies (id_especie),
    CONSTRAINT fk_animais_raca FOREIGN KEY (id_raca)
        REFERENCES racas (id_raca),
    CONSTRAINT fk_animais_tutor FOREIGN KEY (id_tutor)
        REFERENCES tutores (id_tutor),
    CONSTRAINT fk_animais_ong FOREIGN KEY (id_ong)
        REFERENCES ongs (id_ong),
    CONSTRAINT fk_animais_endereco_resgate FOREIGN KEY (id_endereco_resgate)
        REFERENCES enderecos (id_endereco),
    CONSTRAINT ck_animais_sexo CHECK (sexo IN ('MACHO', 'FEMEA', 'DESCONHECIDO')),
    CONSTRAINT ck_animais_porte CHECK (porte IS NULL OR porte IN ('PEQUENO', 'MEDIO', 'GRANDE')),
    CONSTRAINT ck_animais_status CHECK (status_animal IN ('COM_TUTOR', 'RESGATADO', 'EM_TRATAMENTO', 'PRONTO_PARA_ADOCAO', 'ADOTADO')),
    CONSTRAINT ck_animais_responsavel CHECK (id_tutor IS NOT NULL OR id_ong IS NOT NULL)
);

-- =========================================================
-- 9. Tipos de serviço
-- =========================================================

CREATE TABLE tipos_servico (
    id_tipo_servico SERIAL,
    descricao VARCHAR(60) NOT NULL,

    CONSTRAINT pk_tipos_servico PRIMARY KEY (id_tipo_servico),
    CONSTRAINT uk_tipos_servico_descricao UNIQUE (descricao)
);

-- =========================================================
-- 10. Status da solicitação
-- =========================================================

CREATE TABLE status_solicitacao (
    id_status_solicitacao SERIAL,
    descricao VARCHAR(40) NOT NULL,

    CONSTRAINT pk_status_solicitacao PRIMARY KEY (id_status_solicitacao),
    CONSTRAINT uk_status_solicitacao_descricao UNIQUE (descricao)
);

-- =========================================================
-- 11. Solicitações
-- =========================================================

CREATE TABLE solicitacoes (
    id_solicitacao SERIAL,
    id_animal INT,
    id_tutor INT,
    id_ong INT,
    id_tipo_servico INT NOT NULL,
    id_status_solicitacao INT NOT NULL,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP,
    id_endereco_origem INT,
    id_endereco_destino INT,
    data_horario TIMESTAMP,
    detalhes TEXT,

    CONSTRAINT pk_solicitacoes PRIMARY KEY (id_solicitacao),
    CONSTRAINT fk_solicitacoes_animal FOREIGN KEY (id_animal)
        REFERENCES animais (id_animal),
    CONSTRAINT fk_solicitacoes_tutor FOREIGN KEY (id_tutor)
        REFERENCES tutores (id_tutor),
    CONSTRAINT fk_solicitacoes_ong FOREIGN KEY (id_ong)
        REFERENCES ongs (id_ong),
    CONSTRAINT fk_solicitacoes_tipo_servico FOREIGN KEY (id_tipo_servico)
        REFERENCES tipos_servico (id_tipo_servico),
    CONSTRAINT fk_solicitacoes_status FOREIGN KEY (id_status_solicitacao)
        REFERENCES status_solicitacao (id_status_solicitacao),
    CONSTRAINT fk_solicitacoes_endereco_origem FOREIGN KEY (id_endereco_origem)
        REFERENCES enderecos (id_endereco),
    CONSTRAINT fk_solicitacoes_endereco_destino FOREIGN KEY (id_endereco_destino)
        REFERENCES enderecos (id_endereco),
    CONSTRAINT ck_solicitacoes_solicitante CHECK (id_tutor IS NOT NULL OR id_ong IS NOT NULL)
);

-- =========================================================
-- 12. Tarefas
-- =========================================================

CREATE TABLE tarefas (
    id_tarefa SERIAL,
    descricao TEXT NOT NULL,
    id_voluntario INT,
    id_animal INT,
    id_solicitacao INT,
    prioridade VARCHAR(10) NOT NULL,
    status_tarefa VARCHAR(20) NOT NULL,
    data_limite DATE,

    CONSTRAINT pk_tarefas PRIMARY KEY (id_tarefa),
    CONSTRAINT fk_tarefas_voluntario FOREIGN KEY (id_voluntario)
        REFERENCES voluntarios (id_voluntario),
    CONSTRAINT fk_tarefas_animal FOREIGN KEY (id_animal)
        REFERENCES animais (id_animal),
    CONSTRAINT fk_tarefas_solicitacao FOREIGN KEY (id_solicitacao)
        REFERENCES solicitacoes (id_solicitacao),
    CONSTRAINT ck_tarefas_prioridade CHECK (prioridade IN ('BAIXA', 'MEDIA', 'ALTA')),
    CONSTRAINT ck_tarefas_status CHECK (status_tarefa IN ('PENDENTE', 'EM_ANDAMENTO', 'CONCLUIDA', 'CANCELADA'))
);

-- =========================================================
-- 13. Locais de apoio
-- =========================================================

CREATE TABLE locais_apoio (
    id_local_apoio SERIAL,
    nome VARCHAR(120) NOT NULL,
    tipo_local VARCHAR(40) NOT NULL,
    telefone VARCHAR(20),
    horario_funcionamento VARCHAR(80),
    avaliacao DECIMAL(2,1),
    id_endereco INT NOT NULL,

    CONSTRAINT pk_locais_apoio PRIMARY KEY (id_local_apoio),
    CONSTRAINT fk_locais_apoio_endereco FOREIGN KEY (id_endereco)
        REFERENCES enderecos (id_endereco),
    CONSTRAINT ck_locais_apoio_tipo CHECK (tipo_local IN ('CLINICA', 'ABRIGO', 'ONG', 'OUTRO')),
    CONSTRAINT ck_locais_apoio_avaliacao CHECK (avaliacao IS NULL OR avaliacao BETWEEN 0 AND 5)
);

-- =========================================================
-- 14. Gastos
-- =========================================================

CREATE TABLE gastos (
    id_gasto SERIAL,
    id_animal INT NOT NULL,
    descricao VARCHAR(150) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_gasto DATE NOT NULL,

    CONSTRAINT pk_gastos PRIMARY KEY (id_gasto),
    CONSTRAINT fk_gastos_animal FOREIGN KEY (id_animal)
        REFERENCES animais (id_animal),
    CONSTRAINT ck_gastos_valor CHECK (valor >= 0)
);

-- =========================================================
-- 15. Prontuários
-- =========================================================

CREATE TABLE prontuarios (
    id_prontuario SERIAL,
    id_animal INT NOT NULL,
    descricao TEXT NOT NULL,
    data_registro DATE NOT NULL,
    tratamento TEXT,
    observacoes TEXT,

    CONSTRAINT pk_prontuarios PRIMARY KEY (id_prontuario),
    CONSTRAINT fk_prontuarios_animal FOREIGN KEY (id_animal)
        REFERENCES animais (id_animal)
);

-- =========================================================
-- Dados básicos para facilitar os testes
-- =========================================================

INSERT INTO especies (nome) VALUES
('Cachorro'),
('Gato')
ON CONFLICT (nome) DO NOTHING;

INSERT INTO tipos_servico (descricao) VALUES
('Transporte'),
('Castração'),
('Atendimento'),
('Denúncia de maus-tratos'),
('Resgate')
ON CONFLICT (descricao) DO NOTHING;

INSERT INTO status_solicitacao (descricao) VALUES
('Aguardando'),
('Confirmado'),
('A caminho'),
('Concluído'),
('Cancelado')
ON CONFLICT (descricao) DO NOTHING;
