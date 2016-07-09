all: $(filter-out $(wildcard classes), classes)
	javac -cp lib/jade.jar -d classes src/*java

clean:
	rm -r classes
	rm -f APDescription.txt
	rm -f MTPs-Main-Container.txt

classes:
	mkdir classes
