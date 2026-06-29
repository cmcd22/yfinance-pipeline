import sys
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from pyspark.sql.functions import udf
from pyspark.sql.types import StringType
import config

args = getResolvedOptions(sys.argv, ['BRONZE_BUCKET', 'SILVER_BUCKET'])
BRONZE_BUCKET = args['BRONZE_BUCKET']
SILVER_BUCKET = args['SILVER_BUCKET']

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

df = spark.read.json(f"s3://{BRONZE_BUCKET}/ticker=*/quarter_end=*/data.json")


def get_sector(ticker):
    return config.ticker_sector_dict.get(ticker)


sector_udf = udf(get_sector, StringType())

df = (
    df.withColumn("sector", sector_udf(df["ticker"]))
      .withColumn("gross_margin", df["Gross Profit"] / df["Total Revenue"])
      .withColumn("net_margin", df["Net Income"] / df["Total Revenue"])
)

final_df = df.select(df.ticker,
                     df.quarter_end,
                     df.sector,
                     df.gross_margin,
                     df.net_margin)

final_df.write \
        .mode("overwrite") \
        .partitionBy("sector", "quarter_end") \
        .parquet(f"s3://{SILVER_BUCKET}/")
