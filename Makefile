
OS_NAME = $(shell uname -s)
ifeq ($(OS_NAME), Darwin)
  CXX = g++-6
  ifeq (, $(shell which $(CPP)))
    $(error "$(CPP) not found! You need to install gcc 6 to build this!")
	endif
else
  CXX = g++
endif

CXXFLAGS = -Wall  -std=c++14 -m64 -fPIC
LDLIBS = -ldl -lstdc++fs
JAVALIB= -I/opt/jdk1.8.0_171/include -I/opt/jdk1.8.0_171/linux/
.PHONY: all clean

all: tar.so   Makefile

tar.so: CoreCLRHost.cpp CoreCLRHost.hpp utils.hpp Sample1.h  Makefile
	git -C dynamicLinker pull || git clone https://github.com/passedbylove/dynamicLinker
	make -C dynamicLinker CXX=$(CXX)
	$(CXX) $(JAVALIB) $(CXXFLAGS) CoreCLRHost.cpp -shared -o libSample1.so -LdynamicLinker/ -ldynamicLinker $(LDLIBS)


clean:
	rm -rf  tar.so  
	sh -c "stat dynamicLinker/ &> /dev/null && make -C dynamicLinker clean" || true

distclean: clean
	rm -rf dynamicLinker/
