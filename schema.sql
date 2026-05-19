-- Expense System Schema
-- PostgreSQL 18

CREATE TABLE categories (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT categories_name_not_empty  CHECK (length(trim(name)) > 0),
    CONSTRAINT categories_name_trimmed    CHECK (name = trim(name))
);

CREATE TABLE people (
    id         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    email      VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT people_first_name_not_empty CHECK (length(trim(first_name)) > 0),
    CONSTRAINT people_last_name_not_empty  CHECK (length(trim(last_name)) > 0),
    -- Basic email format: must contain exactly one @ with characters either side and a dot after @
    CONSTRAINT people_email_format         CHECK (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$')
);

CREATE TABLE expenses (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    person_id   INT NOT NULL REFERENCES people(id) ON DELETE RESTRICT,
    category_id INT NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    amount      NUMERIC(10, 2) NOT NULL,
    currency    CHAR(3) NOT NULL DEFAULT 'GBP',
    description TEXT,
    expense_date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    approved_at  TIMESTAMPTZ,
    approver_id INT REFERENCES people(id) ON DELETE SET NULL,
    approved     BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT expenses_amount_positive    CHECK (amount > 0),
    CONSTRAINT expenses_amount_max         CHECK (amount <= 9999999.99),
    -- ISO 4217: exactly 3 uppercase letters
    CONSTRAINT expenses_currency_format    CHECK (currency ~ '^[A-Z]{3}$'),
    -- Expense date must not be in the future and not unreasonably old
    CONSTRAINT expenses_date_not_future    CHECK (expense_date <= CURRENT_DATE),
    CONSTRAINT expenses_date_min           CHECK (expense_date >= '2000-01-01')
);

CREATE INDEX idx_expenses_person_id   ON expenses(person_id);
CREATE INDEX idx_expenses_category_id ON expenses(category_id);
CREATE INDEX idx_expenses_expense_date ON expenses(expense_date);
