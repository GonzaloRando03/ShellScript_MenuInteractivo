#!/bin/bash

if [ $1 ]; then
#menu interactivo
	if [ $1 = "-i" ]; then
		opcion=9
		while [ $opcion -ne 0 ]
		do
			clear
			echo ""
			echo "	#################################################"
			echo "	#	  	MENU INTERACTIVO	   	#"
			echo "	#################################################"
			echo "	# 1-Crear lista de usuarios	   		#"
			echo "	# 2-Crear directorios		   		#"
			echo "	# 3-Mover			   		#"
			echo "	# 4-Replicar estructura de directorios		#"
			echo "	# 5-Buscador de archivos			#"
			echo "	# 6-Cambiar permisos				#"
			echo "	# 7-Winrar					#"
			echo "	# 0-Salir					#"
			echo "	#################################################"
			echo ""
			read -p "Menu interactivo> " opcion

			#Crear lista de usuarios
			if [ $opcion -eq 1 ]; then
				clear
				echo "Menu interactivo - Crear lista de usuarios"
				echo ""
				read -p "Escribe los nombres de usuario separados por espacios> " users

				#Separa los usuarios por espacios y los crea
				for user in $users
				do
					useradd -m $user
					password="${user}_iso2122\n${user}_iso2122"
					echo -e $password | passwd $user
				done
				read -p "Usuarios creado, pulsa una tecla para continuar " pause

			#Crear directorios
			elif [ $opcion -eq 2 ]; then
				read -p "Escribe la ruta absuluta donde quieres crear los directorios> " ruta
				if [ -d $ruta ]; then
					read -p "Escribe los nombres de los directorios separados por espacios> " name

					#Separa los directorios por espacios y los crea en la ruta indicada
					for dir in $name
					do
						mkdir $ruta/$dir
					done
					echo ""
					echo "Directorios creados correctamente"
					echo ""
				else
					echo "El directorio especificado no existe"
				fi
				read -p "Pulsa una tecla para continuar " pause
				
			#Mover (con validaciones)
			elif [ $opcion -eq 3 ]; then
				read -p "Escribe la ruta donde esta el fichero> " origen
				if [ -d $origen ]; then
					read -p "Escribe el nombre del fichero o patron> " name
					if [ -f $origen/$name ]; then
						read -p "Escribe la ruta de destino> " destino
						if [ -d $destino ]; then
							mv $origen/$name $destino
							echo ""
							echo "Movido con exito"
							echo ""
						else
							echo "El directorio especificado no existe"
						fi
					else
						echo "El fichero especificado no existe"
					fi
				else
					echo "El directorio especificado no existe"
				fi
				read -p "Pulsa una tecla para continuar " pause
				
			#Copiar esctuctura de directorios
			elif [ $opcion -eq 4 ]; then
				read -p "Escribe la ruta de origen> " origen
				if [ -d $origen ]; then
					read -p "Escribe la ruta de destino> " destino
					if [ -d $destino ]; then
						cp -r $origen/* $destino
						echo ""
						echo "Copiado con exito"
						echo ""
					else
						echo "El directorio especificado no existe"
					fi
				else
					echo "El directorio especificado no existe"
				fi
				read -p "Pulsa una tecla para continuar " pause
				
			elif [ $opcion -eq 5 ]; then
			#Buscador
				read -p "Escribe la ubicacion donde comenzara la busqueda> " origen
				if [ -d $origen ]; then
					read -p "Desea buscar por nombre (S/I/N)> " nombre

					#Condicional que añade el valor al parametro en el caso que sea por nombre
					if [ $nombre = "S" ]; then
						param1=" -name "
						read -p "Ingresa el nombre> " name

					elif [ $nombre = "I" ]; then
						param1=" -iname "
						read -p "Ingresa el nombre> " name
					fi

					read -p "Desea buscar por tipo de archivo (S/N)> " tipo

					#Condicional que añade el valor al parametro en el caso que sea por tipo de archivo
					if [ $tipo = "S" ]; then
						param2=" -type "
						echo ""
						echo "b: Ficheros tipo bloque."
						echo "c: Ficheros tipo carácter."
						echo "d: dicheros tipo directorio"
						echo "f: ficheros tipo ordinario"
						echo "l: ficheros tipo simbólico."
						echo "p: ficheros tipo tubería con nombre"
						echo "s: socket conexión a red."
						echo ""
						read -p "Ingresa el tipo de archivo> " tipe

					fi

					read -p "Desea buscar por usuario (S/N)> " usuario

					#Condicional que añade el valor al parametro en el caso que sea por usuario
					if [ $usuario = "S" ]; then
						param3=" -type "
						read -p "Ingresa el nombre del usuario> " user

					fi

					read -p "Desea buscar por tamaño en Megas (S/N)> " tamano

					#Condicional que añade el valor al parametro en el caso que sea por tamaño
					if [ $tamano = "S" ]; then
						read -p "Ingresa el maximo> " max
						read -p "Ingresa el minimo> " min

						if [ $max > $min ]; then
							valorMax="+${max}M "
							valorMin="-${min}M"
							param4=" -size "
						fi

					fi

					read -p "Indica si desea un print o un ls (P/L)> " lsPrint

					#Condicional que añade el valor al parametro en el caso que sea ls
					if [ $lsPrint = "L" ]; then
						ultimoParam=" -ls "

					fi

					read -p "Indica si desea volcar la salida en un fichero (S/N)> " fichero

					#Condicional que añade el valor al parametro en el caso que sea volcado
					if [ $fichero = "S" ]; then
						read -p "Indica nombre del fichero> " fich
						volcado=" > ${fich}"

					fi
					eval "find $origen $param1 $name $param2 $tipe $param3 $user $param4 $valorMax $valorMin $ultimoParam $volcado"


				else
					echo "El directorio especificado no existe"
				fi
				read -p "Pulsa una tecla para continuar " pause
				
			#Permisos
			elif [ $opcion -eq 6 ]; then

				#Pregunta si es recursivo
				read -p "Es un directorio con lo que quieres trabajar? (S/N)> " dir
				if [ $dir = "S" ]; then
					read -p "Indica si quieres que cambie de manera recursiva (S/N)> " rec
					if [ $rec = "S" ]; then
						recursivo=" -R"

					fi
				fi

				#Valida el destino
				read -p "Escribe a que quieres cambiar el permiso (con ruta)> " destino
				if [ -d $destino ] || [ -f $destino ]; then
					echo ""
					echo "u: usuarios"
					echo "g: grupos"
					echo "o: otros"
					echo ""
					read -p "Escribe a quien le vas a cambiar los permisos> " who
					read -p "Quita permisos, da permisos (Q/D)> " accion

					#Dar o quitar permisos
					if [ $accion = "Q" ]; then
						action="-"
					else
						action="+"
					fi
					echo ""
					echo "x: ejecucion"
					echo "r: lectura"
					echo "w: escritura"
					echo ""
					read -p "Escribe el permiso que quieres dar> " perm

					#Prepara la variable
					permiso="${who}${action}${perm} "

					eval "chmod $permiso $destino $recursivo"
					read -p "Escribe el permiso que quieres dar> " perm
					echo "Permisos cambiados"

				else
					echo "El directorio especificado no existe"
				fi
				read -p "Pulsa una tecla para continuar " pause
				
			#Winrar
			elif [ $opcion -eq 7 ]; then
				read -p "Escribe el nombre del archivo(con extension)> " archivo
				read -p "Comprimir o descomprimir(C/D)> " tipo
				if [ $tipo = "D" ]; then
						tar -xvf $archivo
					else
						read -p "Escribe el directorio que quieres comprimir> " dir
						if [ -d $dir  ]; then
							tar -cvf $archivo $dir
						else
							echo "El directorio no existe"
						fi
					fi

				read -p "Pulsa una tecla para continuar " pause
			elif [ $opcion -eq 0 ]; then
				echo ""

			else
				echo "Opcion incorrecta"
				read -p "Pulsa una tecla para continuar " pause
			fi
			
		done

		echo "Bye"

	elif [ $1 = "-h" ]; then
		echo "Ayuda: Introduce -i para entrar al modo interactivo o -v para ver la version."
		echo "	Opciones del menu interactivo:"
		echo "	1-Crear lista de usuarios: escribes un numero de nombres de usuarios y todos se crean con una contraseña"
		echo ""
		echo "	2-Crear directorios: crea un numero especifico de directorios"
		echo ""
		echo "	3-Mover: mueve ficheros o directorios"
		echo ""
		echo "	4-Replicar estructura de directorios: replica una estructura de un directorio a otro"
		echo ""
		echo "	5-Buscador de archivos: busca archivos o directorios segun los parametros especificados"
		echo ""
		echo "	6-Cambiar permisos: cambia permisos de un fichero o directorio"
		echo ""
		echo "	7-Winrar: comprime o descomprime directorios"
		
	elif [ $1 = "-v" ]; then
		echo "Version 1.0 creado por Gonzalo Rando Serna"
			
	else
		echo "Opcion incorrecta"
	fi

else
	echo "ERROR: debe escribir un parametro, -h para ayuda"
fi

echo ""