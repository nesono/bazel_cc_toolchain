#include "hello_lib.h"
#include <iostream>

int main() {
  if (hello_universe() == std::string("Hello Universe!\n")) {
    std::cout << "Test passed\n";
    return 0;
  } else {
    std::cout << "Test FAILED\n";
    return 1;
  }
}
