#!/bin/bash
java -cp lib/jade.jar:classes jade.Boot -gui -host 127.0.0.1 -agents "TaskAdministrator:BalonPerinKristoffersen.DistributedSolver.TaskAdministrator;compute01:BalonPerinKristoffersen.DistributedSolver.AdditionSolver;compute02:BalonPerinKristoffersen.DistributedSolver.AdditionSolver;compute03:BalonPerinKristoffersen.DistributedSolver.SubstractionSolver;compute04:BalonPerinKristoffersen.DistributedSolver.SubstractionSolver;compute05:BalonPerinKristoffersen.DistributedSolver.DivisionSolver;compute06:BalonPerinKristoffersen.DistributedSolver.DivisionSolver;compute07:BalonPerinKristoffersen.DistributedSolver.MultiplicationSolver;compute08:BalonPerinKristoffersen.DistributedSolver.MultiplicationSolver;"
