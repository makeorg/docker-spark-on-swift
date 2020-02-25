# builder image
FROM maven:3.5 as builder

RUN \
  curl -L https://github.com/CODAIT/stocator/archive/v1.0.37.tar.gz -o stocator-1.0.37.tar.gz && \
  tar xzvf stocator-1.0.37.tar.gz && \
  cd stocator-1.0.37 && \
  mvn clean package -Dmaven.test.skip -Pall-in-one && \
  cd .. && \
  mv stocator-1.0.37 /opt/stocator && \
  rm stocator-1.0.37.tar.gz

# final image
FROM rappdw/docker-java-python

RUN \
  curl -O http://mirrors.ircam.fr/pub/apache/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz && \
  tar xzvf hadoop-3.2.1.tar.gz && \
  mv hadoop-3.2.1 /opt/hadoop && \
  rm hadoop-3.2.1.tar.gz

RUN \
  curl -O https://archive.apache.org/dist/spark/spark-2.2.1/spark-2.2.1-bin-without-hadoop.tgz && \
  tar xzvf spark-2.2.1-bin-without-hadoop.tgz && \
  mv spark-2.2.1-bin-without-hadoop /opt/spark && \
  rm spark-2.2.1-bin-without-hadoop.tgz

COPY --from=builder /opt/stocator/target/stocator-1.0.37-jar-with-dependencies.jar /opt/stocator.jar

COPY spark-env.sh /opt/spark/conf
