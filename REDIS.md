\# Redis Integration



\## Purpose



Redis is integrated into the capstone as a fast in-memory cache layer alongside PostgreSQL.



PostgreSQL remains the system of record for persistent application data such as users, categories, and audit logs. Redis is used for data that benefits from very fast temporary access.



\## Why Redis?



Redis was selected because it provides:



\* Very fast in-memory reads and writes

\* Simple key-value storage

\* Low-latency caching

\* Key expiration using TTL

\* Reduced repeated database queries



Redis does not replace PostgreSQL.



\## Problem Redis Solves



Frequently requested information can be temporarily stored in Redis so that the application does not need to query PostgreSQL every time.



The intended flow is:



```text

Application

&#x20;   |

&#x20;   v

Redis Cache

&#x20;   |

&#x20;   +---- Cache HIT ----> Return cached data

&#x20;   |

&#x20;   +---- Cache MISS ---> Query PostgreSQL

&#x20;                             |

&#x20;                             v

&#x20;                        Store in Redis

&#x20;                             |

&#x20;                             v

&#x20;                        Return data

```



\## Why Not Store Everything in Redis?



PostgreSQL is the authoritative persistent database.



PostgreSQL is responsible for:



\* Users

\* Categories

\* Audit logs

\* Relationships

\* Transactions

\* Persistent data



Redis is responsible only for temporary/high-speed cached data.



If Redis becomes unavailable, the application can fall back to PostgreSQL.



\## Example



A frequently accessed category can be cached using:



```text

SET capstone:category:1 "Electronics"

```



It can then be retrieved with:



```text

GET capstone:category:1

```



A time-to-live can be applied:



```text

EXPIRE capstone:category:1 300

```



This causes the cached value to expire after 300 seconds.



\## PostgreSQL vs Redis



| Requirement                | PostgreSQL          | Redis     |

| -------------------------- | ------------------- | --------- |

| Persistent relational data | Yes                 | No        |

| Foreign keys               | Yes                 | No        |

| Complex SQL queries        | Yes                 | No        |

| Transactions               | Yes                 | Limited   |

| Fast temporary cache       | Possible            | Excellent |

| Key expiration             | Not primary purpose | Yes       |

| Source of truth            | Yes                 | No        |



\## Verification



Redis was verified using:



```text

redis-cli ping

```



Result:



```text

PONG

```



A test key was successfully created, retrieved, and deleted:



```text

SET capstone:test "Redis is working"

GET capstone:test

DEL capstone:test

```



The successful `PONG`, `SET`, `GET`, and `DEL` commands confirm that Redis is operational.



\## Design Decision



Redis is used as a performance layer rather than as the primary database.



This design allows PostgreSQL to provide durable relational storage while Redis provides fast access to frequently requested temporary data.
## Cache Demonstration

A Redis cache entry was created for frequently accessed category information.

Commands tested:

    SET capstone:categories "7 categories loaded from PostgreSQL"

    GET capstone:categories

    EXPIRE capstone:categories 300

    TTL capstone:categories

The Redis server successfully returned the cached category information and assigned a 300-second TTL.

This demonstrates the intended caching pattern:

PostgreSQL → Redis cache → Fast repeated access

PostgreSQL remains the source of truth, while Redis provides temporary high-speed access.



