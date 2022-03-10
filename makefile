all: clean
	nvcc main.cu -o cuda

run:
	rm -f cuda
	nvcc main.cu -o cuda
	./cuda

clean:
	rm -f cuda