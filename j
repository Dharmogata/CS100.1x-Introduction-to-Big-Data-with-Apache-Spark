
Spark Logo + Python Logo
Spark Tutorial: Learning Apache Spark
This tutorial will teach you how to use Apache Spark, a framework for large-scale data processing, within a notebook. Many traditional frameworks were designed to be run on a single computer. However, many datasets today are too large to be stored on a single computer, and even when a dataset can be stored on one computer (such as the datasets in this tutorial), the dataset can often be processed much more quickly using multiple computers. Spark has efficient implementations of a number of transformations and actions that can be composed together to perform data processing and analysis. Spark excels at distributing these operations across a cluster while abstracting away many of the underlying implementation details. Spark has been designed with a focus on scalability and efficiency. With Spark you can begin developing your solution on your laptop, using a small dataset, and then use that same code to process terabytes or even petabytes across a distributed cluster.
During this tutorial we will cover:
Part 1: Basic notebook usage and Python integration
Part 2: An introduction to using Apache Spark with the Python pySpark API running in the browser
Part 3: Using RDDs and chaining together transformations and actions
Part 4: Lambda functions
Part 5: Additional RDD actions
Part 6: Additional RDD transformations
Part 7: Caching RDDs and storage options
Part 8: Debugging Spark applications and lazy evaluation
The following transformations will be covered:
#### map(), mapPartitions(), mapPartitionsWithIndex(), filter(), flatMap(), reduceByKey(), groupByKey() #### The following actions will be covered:
#### first(), take(), takeSample(), takeOrdered(), collect(), count(), countByValue(), reduce(), top() #### Also covered:
#### cache(), unpersist(), id(), setName() #### Note that, for reference, you can look up the details of these methods in Spark's Python API
Part 1: Basic notebook usage and Python integration 
(1a) Notebook usage
A notebook is comprised of a linear sequence of cells. These cells can contain either markdown or code, but we won't mix both in one cell. When a markdown cell is executed it renders formatted text, images, and links just like HTML in a normal webpage. The text you are reading right now is part of a markdown cell. Python code cells allow you to execute arbitrary Python commands just like in any Python shell. Place your cursor inside the cell below, and press "Shift" + "Enter" to execute the code and advance to the next cell. You can also press "Ctrl" + "Enter" to execute the code and remain in the cell. These commands work the same in both markdown and code cells.
In [1]:
# This is a Python cell. You can run normal Python code here...
print 'The sum of 1 and 1 is {0}'.format(1+1)
The sum of 1 and 1 is 2
In [2]:
# Here is another Python cell, this time with a variable (x) declaration and an if statement:
x = 42
if x > 40:
    print 'The sum of 1 and 2 is {0}'.format(1+2)
The sum of 1 and 2 is 3
(1b) Notebook state
As you work through a notebook it is important that you run all of the code cells. The notebook is stateful, which means that variables and their values are retained until the notebook is detached (in Databricks Cloud) or the kernel is restarted (in IPython notebooks). If you do not run all of the code cells as you proceed through the notebook, your variables will not be properly initialized and later code might fail. You will also need to rerun any cells that you have modified in order for the changes to be available to other cells.
In [4]:
# This cell relies on x being defined already.
# If we didn't run the cells from part (1a) this code would fail.
print x * 2
84
(1c) Library imports
We can import standard Python libraries (modules) the usual way. An import statement will import the specified module. In this tutorial and future labs, we will provide any imports that are necessary.
In [5]:
# Import the regular expression library
import re
m = re.search('(?<=abc)def', 'abcdef')
m.group(0)
Out[5]:
'def'
In [6]:
# Import the datetime library
import datetime
print 'This was last run on: {0}'.format(datetime.datetime.now())
This was last run on: 2015-06-07 14:51:24.353691
Part 2: An introduction to using Apache Spark with the Python pySpark API running in the browser
Spark Context
In Spark, communication occurs between a driver and executors. The driver has Spark jobs that it needs to run and these jobs are split into tasks that are submitted to the executors for completion. The results from these tasks are delivered back to the driver.
In part 1, we saw that normal python code can be executed via cells. When using Databricks Cloud this code gets executed in the Spark driver's Java Virtual Machine (JVM) and not in an executor's JVM, and when using an IPython notebook it is executed within the kernel associated with the notebook. Since no Spark functionality is actually being used, no tasks are launched on the executors.
In order to use Spark and its API we will need to use a SparkContext. When running Spark, you start a new Spark application by creating a SparkContext. When the SparkContext is created, it asks the master for some cores to use to do work. The master sets these cores aside just for you; they won't be used for other applications. When using Databricks Cloud or the virtual machine provisioned for this class, the SparkContext is created for you automatically as sc.
(2a) Example Cluster
The diagram below shows an example cluster, where the cores allocated for an application are outlined in purple.
