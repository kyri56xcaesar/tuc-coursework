# Spark & Scala Analytics

Project for a big-data / functional programming course (TUC, 2024). Two **Apache Spark**
applications in Scala read their data from **HDFS**.

## Application 1: Reuters news analysis (RDDs)

Works on the **Reuters RCV1-v2** corpus (documents, their topic categories and stemmed terms)
using the Spark RDD API. For every (category, term stem) pair it computes the **Jaccard index**
between the set of documents in the category and the set of documents containing the term,
and writes the `(category, stem, jaccard)` triples to `hdfs:///results/application1/`.

## Application 2: AIS vessel tracking (DataFrames)

Works on ship position logs from AIS stations using Spark DataFrames. It answers:

1. How many vessel positions were tracked per station per day?
2. Which vessel has the most tracked positions?
3. What is the average speed over ground (SOG) of vessels seen at both station 8006 and
   station 10003 on the same day?
4. What is the average `|Heading − COG|` per station?
5. What are the top 3 most frequent vessel statuses?

## Running

Built against Spark 3.5.1 with Scala 2.13. Needs a local HDFS at `hdfs://localhost:9000`, with the input data
under `/reuters` (Application 1) and the AIS logs (Application 2).

```sh
spark-submit --class Application1 --master "local[*]" <project>.jar
spark-submit --class Application2 --master "local[*]" <project>.jar
```

The version set up for the TUC SoftNet YARN cluster (Spark 2.3.1, Scala 2.11, with `build.sbt`) is on the
`archive/spark-scala-analytics/on_cluster` tag of this repository.
