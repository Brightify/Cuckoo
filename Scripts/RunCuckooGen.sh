GENERATE=1

if [ $GENERATE -ne 0 ]; then
env -i PATH=$PATH PROJECT_DIR=$PROJECT_DIR USE_RUN=$USE_RUN swift "$PROJECT_DIR/GenerateMocksForTests.swift"
fi

