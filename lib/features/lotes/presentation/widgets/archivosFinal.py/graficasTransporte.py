from matplotlib import pyplot as pl
import pandas as pd
import math as mt
from validacion import validaEntero, mensaje
from colorama import Fore, Back, Style, init
import os

# Inicializar colorama
init(autoreset=True)

def limpiarPantalla():
    """Limpia la pantalla de la consola"""
    os.system('cls' if os.name == 'nt' else 'clear')


class datosTransporte:
    def __init__(self, empresa):
        self.__empresa = empresa
    
    def generarDataFrameEstudiantes(self):
        """Genera DataFrame con información de estudiantes"""
        datos = []
        for est in self.__empresa.getEstudiantes():
            ruta = est.rutaAsignada.codigoRuta if est.rutaAsignada else "Sin asignar"
            pago = "Al día" if est.estadoPago else "Pendiente"
            datos.append({
                'Codigo': est.codigoEstudiante,
                'Nombre': f"{est.getNombre()} {est.getApellidoPaterno()}",
                'Edad': est.getEdad(),
                'Ruta': ruta,
                'Estado Pago': pago
            })
        return pd.DataFrame(datos)
    
    def generarDataFrameConductores(self):
        """Genera DataFrame con información de conductores"""
        datos = []
        for cond in self.__empresa.getConductores():
            vehiculo = cond.vehiculoAsignado.codigoVehiculo if cond.vehiculoAsignado else "Sin asignar"
            datos.append({
                'Codigo': cond.codigoConductor,
                'Nombre': f"{cond.getNombre()} {cond.getApellidoPaterno()}",
                'Edad': cond.getEdad(),
                'Vehiculo': vehiculo,
                'Recorridos': cond.recorridos
            })
        return pd.DataFrame(datos)
    
    def generarDataFrameVehiculos(self):
        """Genera DataFrame con información de vehículos"""
        datos = []
        for veh in self.__empresa.getVehiculos():
            conductor = veh.conductorAsignado.codigoConductor if veh.conductorAsignado else "Sin asignar"
            ruta = veh.rutaAsignada.codigoRuta if veh.rutaAsignada else "Sin asignar"
            datos.append({
                'Codigo': veh.codigoVehiculo,
                'Marca': veh.marca,
                'Placa': veh.placa,
                'Capacidad': veh.capacidad,
                'Conductor': conductor,
                'Ruta': ruta
            })
        return pd.DataFrame(datos)
    
    def generarDataFrameRutas(self):
        """Genera DataFrame con información de rutas"""
        datos = []
        for ruta in self.__empresa.getRutas():
            vehiculo = ruta.vehiculoAsignado.codigoVehiculo if ruta.vehiculoAsignado else "Sin asignar"
            conductor = ruta.conductorAsignado.codigoConductor if ruta.conductorAsignado else "Sin asignar"
            datos.append({
                'Codigo': ruta.codigoRuta,
                'Nombre': ruta.nombre,
                'Estudiantes': ruta.getNumeroEstudiantes(),
                'Costo': ruta.tarifaMensual,
                'Ingreso': ruta.calcularIngresoMensual(),
                'Vehiculo': vehiculo,
                'Conductor': conductor
            })
        return pd.DataFrame(datos)
    
    def generarDataFrameAsistencias(self):
        """Genera DataFrame con información de asistencias"""
        datos = []
        for asist in self.__empresa.getAsistencias():
            datos.append({
                'Estudiante': asist.estudiante.codigoEstudiante,
                'Nombre': f"{asist.estudiante.getNombre()} {asist.estudiante.getApellidoPaterno()}",
                'Ruta': asist.ruta.codigoRuta,
                'Fecha': asist.fecha,
                'Estado': asist.estado
            })
        return pd.DataFrame(datos)
    
    def generarGrafico(self):
        """Menú para seleccionar tipo de análisis gráfico"""
        while True:
            limpiarPantalla()
            print(f"\n{Back.MAGENTA}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.MAGENTA}{Style.BRIGHT}   GENERADOR DE GRÁFICOS - TRANSPORTE ESCOLAR{Style.RESET_ALL}")
            print(f"{Back.MAGENTA}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.GREEN}[1]{Style.RESET_ALL} Gráficos de Estudiantes")
            print(f"{Fore.YELLOW}[2]{Style.RESET_ALL} Gráficos de Conductores")
            print(f"{Fore.MAGENTA}[3]{Style.RESET_ALL} Gráficos de Vehículos")
            print(f"{Fore.CYAN}[4]{Style.RESET_ALL} Gráficos de Rutas")
            print(f"{Fore.BLUE}[5]{Style.RESET_ALL} Gráficos de Asistencias")
            print(f"{Fore.WHITE}{Style.BRIGHT}[6]{Style.RESET_ALL} Gráficos Consolidados")
            print(f"{Fore.RED}[7]{Style.RESET_ALL} Volver")
            
            opcion = validaEntero(1, 7, "\nSeleccione opción: ")
            
            if opcion == 7:
                break
            
            match opcion:
                case 1: self.graficosEstudiantes()
                case 2: self.graficosConductores()
                case 3: self.graficosVehiculos()
                case 4: self.graficosRutas()
                case 5: self.graficosAsistencias()
                case 6: self.graficosConsolidados()
    
    def graficosEstudiantes(self):
        """Submenú de gráficos para estudiantes"""
        print(f"\n{Back.GREEN}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
        print(f"{Fore.GREEN}{Style.BRIGHT}   GRÁFICOS DE ESTUDIANTES{Style.RESET_ALL}")
        print(f"{Back.GREEN}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
        print(f"{Fore.CYAN}[1]{Style.RESET_ALL} Estudiantes por Ruta")
        print(f"{Fore.CYAN}[2]{Style.RESET_ALL} Estado de Pagos")
        print(f"{Fore.CYAN}[3]{Style.RESET_ALL} Distribución por Edad")
        
        opcion = validaEntero(1, 3, "\nSeleccione gráfico: ")
        objGrafico = grafico()
        
        match opcion:
            case 1:
                # Estudiantes por ruta
                df = self.generarDataFrameEstudiantes()
                conteo = df['Ruta'].value_counts()
                data_grafico = pd.DataFrame({
                    'Ruta': conteo.index,
                    'Cantidad': conteo.values
                })
                print(f"\n{Fore.GREEN}{Style.BRIGHT}DATOS: Estudiantes por Ruta{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Ruta', 'Cantidad', tipo)
            
            case 2:
                # Estado de pagos
                df = self.generarDataFrameEstudiantes()
                conteo = df['Estado Pago'].value_counts()
                data_grafico = pd.DataFrame({
                    'Estado': conteo.index,
                    'Cantidad': conteo.values
                })
                print(f"\n{Fore.GREEN}{Style.BRIGHT}DATOS: Estado de Pagos{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Estado', 'Cantidad', tipo)
            
            case 3:
                # Distribución por edad
                df = self.generarDataFrameEstudiantes()
                conteo = df['Edad'].value_counts().sort_index()
                data_grafico = pd.DataFrame({
                    'Edad': conteo.index,
                    'Cantidad': conteo.values
                })
                print(f"\n{Fore.GREEN}{Style.BRIGHT}DATOS: Distribución por Edad{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Edad', 'Cantidad', tipo)
    
    def graficosConductores(self):
        """Submenú de gráficos para conductores"""
        print(f"\n{Back.YELLOW}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}{Style.BRIGHT}   GRÁFICOS DE CONDUCTORES{Style.RESET_ALL}")
        print(f"{Back.YELLOW}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
        print(f"{Fore.CYAN}[1]{Style.RESET_ALL} Recorridos por Conductor")
        print(f"{Fore.CYAN}[2]{Style.RESET_ALL} Conductores con/sin Vehículo")
        
        opcion = validaEntero(1, 2, "\nSeleccione gráfico: ")
        objGrafico = grafico()
        
        match opcion:
            case 1:
                # Recorridos por conductor
                df = self.generarDataFrameConductores()
                data_grafico = df[['Nombre', 'Recorridos']].sort_values('Recorridos', ascending=False)
                print(f"\n{Fore.YELLOW}{Style.BRIGHT}DATOS: Recorridos por Conductor{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Nombre', 'Recorridos', tipo)
            
            case 2:
                # Conductores con/sin vehículo
                df = self.generarDataFrameConductores()
                df['Estado'] = df['Vehiculo'].apply(lambda x: 'Con Vehículo' if x != 'Sin asignar' else 'Sin Vehículo')
                conteo = df['Estado'].value_counts()
                data_grafico = pd.DataFrame({
                    'Estado': conteo.index,
                    'Cantidad': conteo.values
                })
                print(f"\n{Fore.YELLOW}{Style.BRIGHT}DATOS: Conductores con/sin Vehículo{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Estado', 'Cantidad', tipo)
    
    def graficosVehiculos(self):
        """Submenú de gráficos para vehículos"""
        print(f"\n{Back.MAGENTA}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
        print(f"{Fore.MAGENTA}{Style.BRIGHT}   GRÁFICOS DE VEHÍCULOS{Style.RESET_ALL}")
        print(f"{Back.MAGENTA}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
        print(f"{Fore.CYAN}[1]{Style.RESET_ALL} Capacidad por Vehículo")
        print(f"{Fore.CYAN}[2]{Style.RESET_ALL} Vehículos por Marca")
        print(f"{Fore.CYAN}[3]{Style.RESET_ALL} Vehículos con/sin Ruta")
        
        opcion = validaEntero(1, 3, "\nSeleccione gráfico: ")
        objGrafico = grafico()
        
        match opcion:
            case 1:
                # Capacidad por vehículo
                df = self.generarDataFrameVehiculos()
                data_grafico = df[['Placa', 'Capacidad']]
                print(f"\n{Fore.MAGENTA}{Style.BRIGHT}DATOS: Capacidad por Vehículo{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Placa', 'Capacidad', tipo)
            
            case 2:
                # Vehículos por marca
                df = self.generarDataFrameVehiculos()
                conteo = df['Marca'].value_counts()
                data_grafico = pd.DataFrame({
                    'Marca': conteo.index,
                    'Cantidad': conteo.values
                })
                print(f"\n{Fore.MAGENTA}{Style.BRIGHT}DATOS: Vehículos por Marca{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Marca', 'Cantidad', tipo)
            
            case 3:
                # Vehículos con/sin ruta
                df = self.generarDataFrameVehiculos()
                df['Estado'] = df['Ruta'].apply(lambda x: 'En Servicio' if x != 'Sin asignar' else 'Sin Ruta')
                conteo = df['Estado'].value_counts()
                data_grafico = pd.DataFrame({
                    'Estado': conteo.index,
                    'Cantidad': conteo.values
                })
                print(f"\n{Fore.MAGENTA}{Style.BRIGHT}DATOS: Vehículos con/sin Ruta{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Estado', 'Cantidad', tipo)
    
    def graficosRutas(self):
        """Submenú de gráficos para rutas"""
        print(f"\n{Back.CYAN}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
        print(f"{Fore.CYAN}{Style.BRIGHT}   GRÁFICOS DE RUTAS{Style.RESET_ALL}")
        print(f"{Back.CYAN}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
        print(f"{Fore.CYAN}[1]{Style.RESET_ALL} Estudiantes por Ruta")
        print(f"{Fore.CYAN}[2]{Style.RESET_ALL} Ingresos por Ruta")
        print(f"{Fore.CYAN}[3]{Style.RESET_ALL} Costos Mensuales por Ruta")
        
        opcion = validaEntero(1, 3, "\nSeleccione gráfico: ")
        objGrafico = grafico()
        
        match opcion:
            case 1:
                # Estudiantes por ruta
                df = self.generarDataFrameRutas()
                data_grafico = df[['Nombre', 'Estudiantes']].sort_values('Estudiantes', ascending=False)
                print(f"\n{Fore.CYAN}{Style.BRIGHT}DATOS: Estudiantes por Ruta{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Nombre', 'Estudiantes', tipo)
            
            case 2:
                # Ingresos por ruta
                df = self.generarDataFrameRutas()
                data_grafico = df[['Nombre', 'Ingreso']].sort_values('Ingreso', ascending=False)
                print(f"\n{Fore.CYAN}{Style.BRIGHT}DATOS: Ingresos por Ruta{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Nombre', 'Ingreso', tipo)
            
            case 3:
                # Costos mensuales
                df = self.generarDataFrameRutas()
                data_grafico = df[['Nombre', 'Costo']].sort_values('Costo', ascending=False)
                print(f"\n{Fore.CYAN}{Style.BRIGHT}DATOS: Costos Mensuales por Ruta{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Nombre', 'Costo', tipo)
    
    def graficosAsistencias(self):
        """Submenú de gráficos para asistencias"""
        print(f"\n{Back.BLUE}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
        print(f"{Fore.BLUE}{Style.BRIGHT}   GRÁFICOS DE ASISTENCIAS{Style.RESET_ALL}")
        print(f"{Back.BLUE}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
        print(f"{Fore.CYAN}[1]{Style.RESET_ALL} Asistencias por Estudiante")
        print(f"{Fore.CYAN}[2]{Style.RESET_ALL} Asistencias por Ruta")
        print(f"{Fore.CYAN}[3]{Style.RESET_ALL} Estados de Asistencia (Presente/Ausente)")
        print(f"{Fore.CYAN}[4]{Style.RESET_ALL} Asistencias por Fecha")
        
        opcion = validaEntero(1, 4, "\nSeleccione gráfico: ")
        objGrafico = grafico()
        
        match opcion:
            case 1:
                # Asistencias por estudiante
                df = self.generarDataFrameAsistencias()
                df_presentes = df[df['Estado'] == 'Presente']
                conteo = df_presentes['Nombre'].value_counts()
                data_grafico = pd.DataFrame({
                    'Estudiante': conteo.index,
                    'Asistencias': conteo.values
                })
                print(f"\n{Fore.BLUE}{Style.BRIGHT}DATOS: Asistencias por Estudiante{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Estudiante', 'Asistencias', tipo)
            
            case 2:
                # Asistencias por ruta
                df = self.generarDataFrameAsistencias()
                conteo = df['Ruta'].value_counts()
                data_grafico = pd.DataFrame({
                    'Ruta': conteo.index,
                    'Total': conteo.values
                })
                print(f"\n{Fore.BLUE}{Style.BRIGHT}DATOS: Asistencias por Ruta{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Ruta', 'Total', tipo)
            
            case 3:
                # Estados de asistencia
                df = self.generarDataFrameAsistencias()
                conteo = df['Estado'].value_counts()
                data_grafico = pd.DataFrame({
                    'Estado': conteo.index,
                    'Cantidad': conteo.values
                })
                print(f"\n{Fore.BLUE}{Style.BRIGHT}DATOS: Estados de Asistencia{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Estado', 'Cantidad', tipo)
            
            case 4:
                # Asistencias por fecha
                df = self.generarDataFrameAsistencias()
                conteo = df['Fecha'].value_counts().sort_index()
                data_grafico = pd.DataFrame({
                    'Fecha': conteo.index,
                    'Total': conteo.values
                })
                print(f"\n{Fore.BLUE}{Style.BRIGHT}DATOS: Asistencias por Fecha{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Fecha', 'Total', tipo)
    
    def graficosConsolidados(self):
        """Submenú de gráficos consolidados que combinan múltiples datos"""
        print(f"\n{Back.WHITE}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
        print(f"{Fore.WHITE}{Style.BRIGHT}   GRÁFICOS CONSOLIDADOS{Style.RESET_ALL}")
        print(f"{Back.WHITE}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
        print(f"{Fore.CYAN}[1]{Style.RESET_ALL} Ocupación por Ruta (Estudiantes vs Capacidad)")
        print(f"{Fore.CYAN}[2]{Style.RESET_ALL} Rendimiento Financiero por Ruta (Ingresos vs Costos)")
        print(f"{Fore.CYAN}[3]{Style.RESET_ALL} Eficiencia Operativa (Recorridos vs Vehículos)")
        print(f"{Fore.CYAN}[4]{Style.RESET_ALL} Tasa de Asistencia por Ruta")
        print(f"{Fore.CYAN}[5]{Style.RESET_ALL} Estado de Pagos vs Asistencias")
        print(f"{Fore.CYAN}[6]{Style.RESET_ALL} Comparativa General del Sistema")
        
        opcion = validaEntero(1, 6, "\nSeleccione gráfico: ")
        objGrafico = grafico()
        
        match opcion:
            case 1:
                # Ocupación por ruta (Estudiantes vs Capacidad)
                df_rutas = self.generarDataFrameRutas()
                df_vehiculos = self.generarDataFrameVehiculos()
                
                datos_consolidados = []
                for _, ruta in df_rutas.iterrows():
                    vehiculo_ruta = df_vehiculos[df_vehiculos['Codigo'] == ruta['Vehiculo']]
                    capacidad = vehiculo_ruta['Capacidad'].values[0] if not vehiculo_ruta.empty else 0
                    datos_consolidados.append({
                        'Ruta': ruta['Nombre'][:20],
                        'Estudiantes': ruta['Estudiantes'],
                        'Capacidad': capacidad
                    })
                
                df_consolidado = pd.DataFrame(datos_consolidados)
                print(f"\n{Fore.WHITE}{Style.BRIGHT}DATOS: Ocupación por Ruta{Style.RESET_ALL}")
                print(df_consolidado.to_string(index=False))
                
                # Gráfico de barras agrupadas
                fig, ax = pl.subplots(figsize=(10, 6))
                x = range(len(df_consolidado))
                ancho = 0.35
                ax.bar([i - ancho/2 for i in x], df_consolidado['Estudiantes'], ancho, label='Estudiantes', color='green')
                ax.bar([i + ancho/2 for i in x], df_consolidado['Capacidad'], ancho, label='Capacidad', color='orange')
                ax.set_xlabel('Ruta')
                ax.set_ylabel('Cantidad')
                ax.set_title('Ocupación por Ruta: Estudiantes vs Capacidad')
                ax.set_xticks(x)
                ax.set_xticklabels(df_consolidado['Ruta'], rotation=45, ha='right')
                ax.legend()
                pl.tight_layout()
                pl.show()
            
            case 2:
                # Rendimiento financiero por ruta
                df_rutas = self.generarDataFrameRutas()
                
                data_grafico = df_rutas[['Nombre', 'Costo', 'Ingreso']].copy()
                data_grafico['Nombre'] = data_grafico['Nombre'].str[:20]
                
                print(f"\n{Fore.WHITE}{Style.BRIGHT}DATOS: Rendimiento Financiero{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                
                # Gráfico de barras agrupadas
                fig, ax = pl.subplots(figsize=(10, 6))
                x = range(len(data_grafico))
                ancho = 0.35
                ax.bar([i - ancho/2 for i in x], data_grafico['Costo'], ancho, label='Costos', color='red')
                ax.bar([i + ancho/2 for i in x], data_grafico['Ingreso'], ancho, label='Ingresos', color='green')
                ax.set_xlabel('Ruta')
                ax.set_ylabel('Monto (S/.)')
                ax.set_title('Rendimiento Financiero por Ruta')
                ax.set_xticks(x)
                ax.set_xticklabels(data_grafico['Nombre'], rotation=45, ha='right')
                ax.legend()
                pl.tight_layout()
                pl.show()
            
            case 3:
                # Eficiencia operativa
                df_conductores = self.generarDataFrameConductores()
                df_vehiculos = self.generarDataFrameVehiculos()
                
                # Recorridos por conductor
                total_recorridos = df_conductores['Recorridos'].sum()
                vehiculos_activos = len(df_vehiculos[df_vehiculos['Ruta'] != 'Sin asignar'])
                vehiculos_inactivos = len(df_vehiculos[df_vehiculos['Ruta'] == 'Sin asignar'])
                
                data_grafico = pd.DataFrame({
                    'Categoría': ['Recorridos Totales', 'Vehículos Activos', 'Vehículos Inactivos'],
                    'Cantidad': [total_recorridos, vehiculos_activos, vehiculos_inactivos]
                })
                
                print(f"\n{Fore.WHITE}{Style.BRIGHT}DATOS: Eficiencia Operativa{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Categoría', 'Cantidad', tipo)
            
            case 4:
                # Tasa de asistencia por ruta
                df_asistencias = self.generarDataFrameAsistencias()
                
                tasa_asistencia = []
                for ruta in df_asistencias['Ruta'].unique():
                    asistencias_ruta = df_asistencias[df_asistencias['Ruta'] == ruta]
                    total = len(asistencias_ruta)
                    presentes = len(asistencias_ruta[asistencias_ruta['Estado'] == 'Presente'])
                    tasa = (presentes / total * 100) if total > 0 else 0
                    tasa_asistencia.append({
                        'Ruta': ruta,
                        'Total Registros': total,
                        'Presentes': presentes,
                        'Tasa (%)': round(tasa, 2)
                    })
                
                data_grafico = pd.DataFrame(tasa_asistencia)
                print(f"\n{Fore.WHITE}{Style.BRIGHT}DATOS: Tasa de Asistencia por Ruta{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico[['Ruta', 'Tasa (%)']], 'Ruta', 'Tasa (%)', tipo)
            
            case 5:
                # Estado de pagos vs asistencias
                df_estudiantes = self.generarDataFrameEstudiantes()
                df_asistencias = self.generarDataFrameAsistencias()
                
                # Contar asistencias por estudiante
                asistencias_por_estudiante = df_asistencias['Estudiante'].value_counts()
                
                # Crear consolidado
                datos_consolidados = []
                for _, est in df_estudiantes.iterrows():
                    asistencias = asistencias_por_estudiante.get(est['Codigo'], 0)
                    datos_consolidados.append({
                        'Estado Pago': est['Estado Pago'],
                        'Asistencias': asistencias
                    })
                
                df_consolidado = pd.DataFrame(datos_consolidados)
                
                # Agrupar por estado de pago
                resumen = df_consolidado.groupby('Estado Pago')['Asistencias'].agg(['sum', 'mean']).reset_index()
                resumen.columns = ['Estado Pago', 'Total Asistencias', 'Promedio']
                resumen['Promedio'] = resumen['Promedio'].round(2)
                
                print(f"\n{Fore.WHITE}{Style.BRIGHT}DATOS: Pagos vs Asistencias{Style.RESET_ALL}")
                print(resumen.to_string(index=False))
                
                # Gráfico de barras agrupadas
                fig, ax = pl.subplots(figsize=(8, 6))
                x = range(len(resumen))
                ancho = 0.35
                ax.bar([i - ancho/2 for i in x], resumen['Total Asistencias'], ancho, label='Total Asistencias', color='blue')
                ax.bar([i + ancho/2 for i in x], resumen['Promedio'], ancho, label='Promedio', color='cyan')
                ax.set_xlabel('Estado de Pago')
                ax.set_ylabel('Cantidad')
                ax.set_title('Relación entre Estado de Pago y Asistencias')
                ax.set_xticks(x)
                ax.set_xticklabels(resumen['Estado Pago'])
                ax.legend()
                pl.tight_layout()
                pl.show()
            
            case 6:
                # Comparativa general del sistema
                df_estudiantes = self.generarDataFrameEstudiantes()
                df_conductores = self.generarDataFrameConductores()
                df_vehiculos = self.generarDataFrameVehiculos()
                df_rutas = self.generarDataFrameRutas()
                df_asistencias = self.generarDataFrameAsistencias()
                
                data_grafico = pd.DataFrame({
                    'Categoría': ['Estudiantes', 'Conductores', 'Vehículos', 'Rutas', 'Asistencias'],
                    'Cantidad': [
                        len(df_estudiantes),
                        len(df_conductores),
                        len(df_vehiculos),
                        len(df_rutas),
                        len(df_asistencias)
                    ]
                })
                
                print(f"\n{Fore.WHITE}{Style.BRIGHT}DATOS: Comparativa General del Sistema{Style.RESET_ALL}")
                print(data_grafico.to_string(index=False))
                
                tipo = validaEntero(1, 4, f"\n{Fore.YELLOW}MENU GRAFICOS{Style.RESET_ALL}\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion: ")
                objGrafico.dibujaGrafico(data_grafico, 'Categoría', 'Cantidad', tipo)


class grafico:
    
    def menuGraficos(self):
        return validaEntero(1,4,"MENU GRAFICOS\n[1] lineas\n[2] barras\n[3] pie\n[4] barras y lineas\nopcion")
    
    def dibujaGrafico(self,data,xabscisa,yordenada,opcion):
        match opcion:
            case 1: self.lineas(data,xabscisa,yordenada) 
            case 2: self.barras(data,xabscisa,yordenada) 
            case 3: self.pie(data,xabscisa,yordenada) 
            case 4: self.barrasLineas(data,xabscisa,yordenada)
    
    def lineas(self,data,xabscisa,yordenada):
        fig, ax = pl.subplots()
        ax.plot(data[xabscisa], data[yordenada])
        ax.set_xlabel(xabscisa)
        ax.set_ylabel(yordenada)
        ax.set_title(f"{yordenada} vs {xabscisa}")
        pl.show()
    
    def barras(self, data, xabscisa, yordenada):
        fig, ax = pl.subplots()
        ancho = 0.6
        ax.bar(data[xabscisa], data[yordenada],color='green',width=ancho)
        ax.set_xlabel(xabscisa)
        ax.set_ylabel(yordenada)
        desplazamiento = 0
        for i, valor in enumerate(data[yordenada]):
            ax.text(i, valor + desplazamiento, str(valor), ha='center', va='bottom')
        ax.set_xticklabels(data[xabscisa], rotation=45, ha='right')
        ax.set_title(f"{yordenada} por {xabscisa}")
        pl.show()
    
    def pie(self, data, xabscisa, yordenada):        
        fig, ax = pl.subplots(figsize=(7, 7))
        labels = data[xabscisa]
        sizes = data[yordenada]
        wedges, texts, autotexts = ax.pie(
                        sizes,
                        labels=labels,
                        autopct='%1.1f%%',
                        startangle=90,
                        pctdistance=1.15,
                        labeldistance=1.30,
                        textprops={'fontsize': 10},
                        wedgeprops=dict(width=0.9)
                    )       
        ax.set_title (
                        f"Distribución de {yordenada.upper()} por {xabscisa.upper()}",
                        pad = 70,
                        fontsize = 16,
                        fontweight='bold'
                    )
        ax.axis('equal')
        pl.tight_layout()
        pl.show()
    
    def barrasLineas(self, data, xabscisa, yordenada):
        fig, ax = pl.subplots(figsize=(8,5))
        ax.bar(data[xabscisa], data[yordenada], color='skyblue', alpha=0.7, label='valores')
        ax.plot(data[xabscisa], data[yordenada], color='red', marker='o', linewidth=2, label='tendencia')
        desplazamiento = 0
        for i, valor in enumerate(data[yordenada]):
            ax.text(i, valor + desplazamiento, str(valor), ha='center', va='bottom')
        ax.set_xlabel(xabscisa)
        ax.set_ylabel(yordenada)
        ax.set_title(f"{yordenada} vs {xabscisa}")
        ax.legend()
        pl.show()
