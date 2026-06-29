import sys
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from pyspark.sql import functions as F

args = getResolvedOptions(sys.argv, ['SILVER_BUCKET', 'GOLD_BUCKET'])
SILVER_BUCKET = args['SILVER_BUCKET']
GOLD_BUCKET = args['GOLD_BUCKET']

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

df = spark.read.parquet(f"s3://{SILVER_BUCKET}")

final_df = df.groupBy("sector", "quarter_end").agg(
    F.avg("gross_margin").alias("avg_gross_margin"),
    F.avg("net_margin").alias("avg_net_margin")
)

final_df.write \
    .mode("overwrite") \
    .partitionBy("sector", "quarter_end") \
    .parquet(f"s3://{GOLD_BUCKET}/")
