create table users (
    id integer primary key,
    name text,
    uclass text,
    booklimit integer,
    created_at,
    updated_at
);

create table books (
    id integer primary key,
    title text,
    author text,
    publisher text,
    isbn text,
    created_at,
    updated_at
);

create table lendbooks (
    id integer primary key,
    books_id integer,
    users_id integer,
    lendday text,
    returnday text,
    created_at,
    updated_at
);