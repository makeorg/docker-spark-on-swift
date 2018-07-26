# builder image
FROM maven:3.5 as builder

RUN \
  curl -L https://github.com/CODAIT/stocator/archive/v1.0.15.tar.gz -o stocator-1.0.15.tar.gz && \
  tar xzvf stocator-1.0.15.tar.gz && \
  cd stocator-1.0.15 && \
  mvn clean package -Pall-in-one && \
  cd .. && \
  mv stocator-1.0.15 /opt/stocator && \
  rm stocator-1.0.15.tar.gz

# final image
FROM rappdw/docker-java-python

RUN \
  curl -O http://mirrors.ircam.fr/pub/apache/hadoop/common/hadoop-3.0.3/hadoop-3.0.3.tar.gz && \
  tar xzvf hadoop-3.0.3.tar.gz && \
  mv hadoop-3.0.3 /opt/hadoop && \
  rm hadoop-3.0.3.tar.gz

RUN \
  curl -O https://archive.apache.org/dist/spark/spark-2.2.1/spark-2.2.1-bin-without-hadoop.tgz && \
  tar xzvf spark-2.2.1-bin-without-hadoop.tgz && \
  mv spark-2.2.1-bin-without-hadoop /opt/spark && \
  rm spark-2.2.1-bin-without-hadoop.tgz

COPY --from=builder /opt/stocator/target/stocator-1.0.15-jar-with-dependencies.jar /opt/stocator.jar

COPY spark-env.sh /opt/spark/conf
