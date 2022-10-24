docker run --rm -v "$(pwd)":/workspace -w /workspace builder bash -cl "swift build --product WeightScanner -c release -Xswiftc -g"
docker run --rm -v "$(pwd)":/workspace -w /workspace builder bash -cl "./package.sh"
open .build/lambda/WeightScanner

