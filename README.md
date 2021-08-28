# Multiarch Postgresql Client Docker Image

Postgres client Docker image for both amd64 and arm64 (Apple Silicon)

Includes:

- Postgresql 12 and client tools
- Postgresql 13 and client tools
- PostGIS 3 for both installs
- Various admin tools like `wget` `jq` `git` and `vim`

## Examples

Run a shell with all the tools and databases available:

```sh
$ docker run -it --rm ikc9/postgres-client
```

Spawning a postgres client shell for a connection string:

```sh
$ docker run -it --network=compose_stack_default --rm nikc9/postgres-client psql postgresql://user:pass@postgres/database
```

schema only `pg_dump` from server to the current directory

```sh
docker run -it -v $PWD:/data/ --network=host --rm nikc9/postgres-client pg_dump -f /data/dump.sql -s postgresql://opennem:opennem@127.0.0.1:15433/opennem
```
