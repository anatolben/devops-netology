# Решение домашнего задания к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

**Ответ.**  
```dockerfile
ARG IMAGE_TAG=7

FROM centos:$IMAGE_TAG

WORKDIR /tmp

ARG ES_VERSION=8.0.0
ENV ES_VER=${ES_VERSION}
RUN yum install -y --setopt=tsflags=nodocs \
    perl-Digest-SHA \
 && curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VER}-linux-x86_64.tar.gz -o elasticsearch-${ES_VER}-linux-x86_64.tar.gz \
 && curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 -o elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 \
 && shasum -a 512 -c elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 \
 && tar -xzf elasticsearch-${ES_VER}-linux-x86_64.tar.gz



FROM centos:$IMAGE_TAG

MAINTAINER anatolben <github.com/anatolben>

EXPOSE 9200
EXPOSE 9300
USER 0

ARG ES_VERSION=8.0.0
ENV ES_VER=${ES_VERSION} \
    ES_HOME=/home/el/elasticsearch \
    ES_PATH_CONF=/home/el/elasticsearch/config

COPY --from=0 /tmp/elasticsearch-${ES_VER} ${ES_HOME}
RUN mkdir -p /var/lib/elasticsearch/log \
 && mkdir -p /var/lib/elasticsearch/data \
 && adduser -u 1000 el \
 && chown -R el:el ${ES_HOME} \
 && chown -R el:el /var/lib/elasticsearch

WORKDIR ${ES_HOME}
USER 1000
CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]
```

[anatolben/netology:elasticsearch-8.0.0-centos7](https://hub.docker.com/layers/195065968/anatolben/netology/elasticsearch-8.0.0-centos7/images/sha256-42765de7ccea00843a690f0b6bbe6b76eeed3228c5a8a17ce91eabdabad31407?context=repo)  


```json
{
  "name" : "netology_test",
  "cluster_name" : "netology",
  "cluster_uuid" : "1Pi3aG6LSCuMokgrhLwVLw",
  "version" : {
    "number" : "8.0.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "1b6a7ece17463df5ff54a3e1302d825889aa1161",
    "build_date" : "2022-02-03T16:47:57.507843096Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

**Ответ.**  
[screenshot 01](https://i.imgur.com/1MqZf6D.png)  
![screenshot 01](https://i.imgur.com/1MqZf6D.png)  

Желтый означает что, все шарды доступны, а реплики не все. В этом случае любые запросы к индексу возвращаются с правильными результатами, но если узел, содержащий мастер шард, будет не доступен, могут потеряться данные.  
Так же желтый может означать неверные настройки конфигурации.

"Shards are only relocated if it is possible to do so without breaking another routing constraint, such as never allocating a primary and replica shard on the same node."  
[источник](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-cluster.html#cluster-shard-allocation-filtering)

Желтые статусы потому, что две копии шарда не могут находиться на одном узле (а узел один). Поэтому настроенные реплики отсутствуют.   

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

**Ответ.**

[screenshot 02](https://i.imgur.com/AbjMLBJ.png)  
![screenshot 02](https://i.imgur.com/AbjMLBJ.png)  

[screenshot 03](https://i.imgur.com/bCN9ucG.png)  
![screenshot 03](https://i.imgur.com/bCN9ucG.png)  

[screenshot 04](https://i.imgur.com/7aJSFSj.png)  
![screenshot 04](https://i.imgur.com/7aJSFSj.png)  

[screenshot 05](https://i.imgur.com/hAfvXu4.png)  
![screenshot 05](https://i.imgur.com/hAfvXu4.png)  

---
