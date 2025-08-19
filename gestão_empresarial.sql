-- Criação do schema
CREATE SCHEMA IF NOT EXISTS gestao_empresarial;
USE gestao_empresarial;

-- Tabela de funcionários
CREATE TABLE funcionario (
  cpf CHAR(11) NOT NULL PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  endereco VARCHAR(100),
  nascimento DATE NOT NULL,
  salario DECIMAL(10,2) NOT NULL CHECK (salario >= 1500)
);

-- Tabela de departamentos
CREATE TABLE departamento (
  id INT NOT NULL PRIMARY KEY,
  nome VARCHAR(30) NOT NULL UNIQUE,
  gerente_cpf CHAR(11),
  inicio_gerencia DATE,
  FOREIGN KEY (gerente_cpf) REFERENCES funcionario(cpf)
);

-- Tabela de locais dos departamentos
CREATE TABLE departamento_local (
  id_departamento INT NOT NULL,
  local VARCHAR(30) NOT NULL,
  PRIMARY KEY (id_departamento, local),
  FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

-- Tabela de projetos
CREATE TABLE projeto (
  id INT NOT NULL PRIMARY KEY,
  nome VARCHAR(30) NOT NULL UNIQUE,
  descricao VARCHAR(100),
  local VARCHAR(30),
  id_departamento INT NOT NULL,
  FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

-- Tabela de alocação de funcionários em projetos
CREATE TABLE trabalha_em (
  cpf_funcionario CHAR(11) NOT NULL,
  id_projeto INT NOT NULL,
  horas DECIMAL(4,1) NOT NULL,
  PRIMARY KEY (cpf_funcionario, id_projeto),
  FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf),
  FOREIGN KEY (id_projeto) REFERENCES projeto(id)
);

-- Tabela de dependentes
CREATE TABLE dependente (
  cpf_funcionario CHAR(11) NOT NULL,
  nome_dependente VARCHAR(30) NOT NULL,
  sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
  nascimento DATE NOT NULL,
  relacao VARCHAR(20),
  PRIMARY KEY (cpf_funcionario, nome_dependente),
  FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(cpf)
);

-- Inserção de funcionários
INSERT INTO funcionario VALUES
('12345678901', 'Ana Souza', 'Rua das Flores, 123', '1990-05-10', 3500.00),
('98765432100', 'Carlos Lima', 'Av. Brasil, 456', '1985-08-22', 4200.00),
('11122233344', 'Beatriz Costa', 'Rua Central, 789', '2000-01-15', 1800.00);

-- Inserção de departamentos
INSERT INTO departamento VALUES
(1, 'Recursos Humanos', '12345678901', '2020-01-01'),
(2, 'TI', '98765432100', '2019-06-15');

-- Inserção de locais dos departamentos
INSERT INTO departamento_local VALUES
(1, 'Goiânia'),
(2, 'São Paulo'),
(2, 'Campinas');

-- Inserção de projetos
INSERT INTO projeto VALUES
(101, 'Sistema RH', 'Automatização de processos de RH', 'Goiânia', 1),
(102, 'Infraestrutura Cloud', 'Migração para nuvem', 'São Paulo', 2);

-- Inserção de alocação em projetos
INSERT INTO trabalha_em VALUES
('12345678901', 101, 20.5),
('98765432100', 102, 35.0),
('11122233344', 102, 15.0);

-- Inserção de dependentes
INSERT INTO dependente VALUES
('12345678901', 'Lucas Souza', 'M', '2010-03-12', 'Filho'),
('98765432100', 'Marina Lima', 'F', '2012-07-08', 'Filha');

-- Selects úteis

-- Funcionários com idade >= 18
SELECT nome, nascimento,
  TIMESTAMPDIFF(YEAR, nascimento, CURDATE()) AS idade
FROM funcionario
WHERE TIMESTAMPDIFF(YEAR, nascimento, CURDATE()) >= 18;

-- Funcionários com faixa salarial
SELECT nome, salario,
  CASE
    WHEN salario >= 4000 THEN 'Alto'
    WHEN salario >= 2500 THEN 'Médio'
    ELSE 'Baixo'
  END AS faixa_salarial
FROM funcionario;

-- Projetos e seus departamentos
SELECT p.nome AS projeto, d.nome AS departamento, p.local
FROM projeto p
JOIN departamento d ON p.id_departamento = d.id;

-- Dependentes por funcionário
SELECT f.nome AS funcionario, d.nome_dependente