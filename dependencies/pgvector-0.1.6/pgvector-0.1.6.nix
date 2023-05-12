{ buildPythonPackage, fetchPypi, lib, python, setuptools }:

buildPythonPackage rec {
  pname = "pgvector";
  version = "0.1.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c53d49dae7c5e0e39bc2f05ce8599a853383f11ce9ffaa7bd0924844e16c7bf4";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  meta = with lib; {
    description = ''
# pgvector-python

[pgvector](https://github.com/pgvector/pgvector) support for Python

Great for online recommendations :tada:

Supports [Django](https://github.com/django/django), [SQLAlchemy](https://github.com/sqlalchemy/sqlalchemy), [Psycopg 3](https://github.com/psycopg/psycopg), [Psycopg 2](https://github.com/psycopg/psycopg2), and [asyncpg](https://github.com/MagicStack/asyncpg)

[![Build Status](https://github.com/pgvector/pgvector-python/workflows/build/badge.svg?branch=master)](https://github.com/pgvector/pgvector-python/actions)

## Installation

Run:

```sh
pip install pgvector
```

And follow the instructions for your database library:

- [Django](#django)
- [SQLAlchemy](#sqlalchemy)
- [Psycopg 3](#psycopg-3)
- [Psycopg 2](#psycopg-2)
- [asyncpg](#asyncpg)

Or check out some examples:

- [Image search](examples/pytorch_image_search.py) with PyTorch
- [Implicit feedback recommendations](examples/implicit_recs.py) with Implicit
- [Explicit feedback recommendations](examples/surprise_recs.py) with Surprise
- [Recommendations](examples/lightfm_recs.py) with LightFM

## Django

Create the extension

```python
from pgvector.django import VectorExtension

class Migration(migrations.Migration):
    operations = [
        VectorExtension()
    ]
```

Add a vector field

```python
from pgvector.django import VectorField

class Item(models.Model):
    factors = VectorField(dimensions=3)
```

Insert a vector

```python
item = Item(factors=[1, 2, 3])
item.save()
```

Get the nearest neighbors to a vector

```python
from pgvector.django import L2Distance

Item.objects.order_by(L2Distance('factors', [3, 1, 2]))[:5]
```

Also supports `MaxInnerProduct` and `CosineDistance`

Add an approximate index

```python
from pgvector.django import IvfflatIndex

class Item(models.Model):
    class Meta:
        indexes = [
            IvfflatIndex(
                name='my_index',
                fields=['factors'],
                lists=100,
                opclasses=['vector_l2_ops']
            )
        ]
```

Use `vector_ip_ops` for inner product and `vector_cosine_ops` for cosine distance

## SQLAlchemy

Add a vector column

```python
from pgvector.sqlalchemy import Vector

class Item(Base):
    factors = Column(Vector(3))
```

Insert a vector

```python
item = Item(factors=[1, 2, 3])
session.add(item)
session.commit()
```

Get the nearest neighbors to a vector

```python
session.query(Item).order_by(Item.factors.l2_distance([3, 1, 2])).limit(5).all()
```

Also supports `max_inner_product` and `cosine_distance`

Add an approximate index

```python
index = Index('my_index', Item.factors,
    postgresql_using='ivfflat',
    postgresql_with={'lists': 100},
    postgresql_ops={'factors': 'vector_l2_ops'}
)
index.create(engine)
```

Use `vector_ip_ops` for inner product and `vector_cosine_ops` for cosine distance

## Psycopg 3

Register the vector type with your connection

```python
from pgvector.psycopg import register_vector

register_vector(conn)
```

Insert a vector

```python
factors = np.array([1, 2, 3])
conn.execute('INSERT INTO item (factors) VALUES (%s)', (factors,))
```

Get the nearest neighbors to a vector

```python
conn.execute('SELECT * FROM item ORDER BY factors <-> %s LIMIT 5', (factors,)).fetchall()
```

## Psycopg 2

Register the vector type with your connection or cursor

```python
from pgvector.psycopg2 import register_vector

register_vector(conn)
```

Insert a vector

```python
factors = np.array([1, 2, 3])
cur.execute('INSERT INTO item (factors) VALUES (%s)', (factors,))
```

Get the nearest neighbors to a vector

```python
cur.execute('SELECT * FROM item ORDER BY factors <-> %s LIMIT 5', (factors,))
cur.fetchall()
```

## asyncpg

Register the vector type with your connection

```python
from pgvector.asyncpg import register_vector

await register_vector(conn)
```

Insert a vector

```python
factors = np.array([1, 2, 3])
await conn.execute('INSERT INTO item (factors) VALUES ($1)', factors)
```

Get the nearest neighbors to a vector

```python
await conn.fetch('SELECT * FROM item ORDER BY factors <-> $1 LIMIT 5', factors)
```

## History

View the [changelog](https://github.com/pgvector/pgvector-python/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/pgvector/pgvector-python/issues)
- Fix bugs and [submit pull requests](https://github.com/pgvector/pgvector-python/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/pgvector/pgvector-python.git
cd pgvector-python
pip install -r requirements.txt
createdb pgvector_python_test
pytest
```

'';
    license = licenses.mit;
    homepage = "None";
    maintainers = with maintainers; [ ];
  };
}
