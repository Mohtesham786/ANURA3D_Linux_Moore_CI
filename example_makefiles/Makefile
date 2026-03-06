#....................................................definicion general de compilacion
 comp = ifort     -c   -align dcommons   -no-vec           

#....................................................linea para linkar en paralelo
#link = f90 -lc -64 -mips4 -r14000 -pfa  

#....................................................linea para linkar en serie
 link = ifort    -lc 

#....................................................grupo de archivos con posible optimizacion -O2
OBJ1 =  code_bright.o\
	code_bright_main.o\
	code_bright_retraso.o\
	assembling.o\
	bcond.o\
        bcond_atmos.o\
	cputime_unix.o\
	convergence.o\
	depvare_upd.o\
	depvarn_upd.o\
	element.o\
	flux.o\
	flux_upd.o\
	influence.o\
	nr.o\
	nr_tep.o\
	nr_creep.o\
	porosity_upd.o\
	read_general.o\
	read_grid.o\
	strain.o\
	stress_upd.o\
	stress_upd_viscous.o\
	stress_upd_tep.o\
	stress_upd_argillite.o\
	stress_argillite.o\
	stress_argillite_soft.o\
	write.o\
        write_gid.o\
        write_gidnew.o\
	constitut.o

#...........................................grupo de archivos con dificultades de optimizacion
OBJ2 = nr_balance_conti.o\
      	bcond_flow.o

#........................................grupo de subrutinas con conveniencia de optimizacion -O2
OBJ3 = cbnag.o\
	solvuns.o

#...........................................grupo de archivos con conveniencia de paralelismo
OBJ4 = sparse.o

#...................................................code_bright se hace asi:
code_bright.exe: $(OBJ1) $(OBJ2) $(OBJ3) $(OBJ4)
	$(link) -o $@ $(OBJ1) $(OBJ2) $(OBJ3) $(OBJ4)

#..........................................opciones de compilacion por grupos de subrutinas
$(OBJ1):
	$(comp) -O2  $*.f

$(OBJ2):
	$(comp) -O2  $*.f

$(OBJ3):
	$(comp) -O2  $*.f

$(OBJ4):
	$(comp) -O3  $*.f
#
#
#
#
#
#......................................................linea para compilar en paralelo
#	$(comp) -O3 -pfa list  $*.f 
#......................................................linea para compilar en serie 
#
#
#
#
#
#    COMENTARIOS RELATIVOS AL PROCESO DE COMPILACION Y LINKADO
#
#
# la opcion de -static ha sido anadida al ver que el caso 'mmb' no
# conseguia converger aunque si avanzaba. O2 no era posible en 'porosity_upd'
# Por otro lado, al introducir
# esta opcion, La subrutina en el archivo 'porosity_upd' ha pasado a 
# poderse compilar con O2 sin errores que antes impedian su optimizacion
# (la porosidad tomaba valores raros, era curioso que al poner un 
# WRITE interno para ver lo que ocurria, los problemas desaparecian; 
# es decir, el WRITE impedia cierta optimizacion del nivel O2). 
#
#
# El nivel de optimizacion O3 empeora el comportamiento global aunque
# parece que el cputime de resolucion de sistemas disminuyE
# 
# O3 solamente en las subrutinas de sistemas de ecuaciones no
# da buen resultado, de hecho acaba por no converger
#
# INLINING: de momento solo lo hago con las subrutinas de 
# constitut.f, pero por ahora no converge, es decir, han 
# cambiado de order las operaciones matematicas y da lugar
# a numeros diferentes. Probare con nuevas tolerancias.
# comp = f77 -c -col72 -static -pfa -64 -mips4 -r10000 
# comp = f77 -c -col72 -static -WK,\
# -inline_from_files=constitut.f:strain.f:assembling.f
# comp =  f77 -c -col72 -static 
# comp =  f77 -c -col72  -64 -mips4 -static -align64
# nr_balance_homog.o\
# nr_mech_joint.o\
# nr_balance_joint.o\
# stress_upd_joint.o\
