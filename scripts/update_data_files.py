"""Script to rewrite all remaining guias data files with temperaturaC and humedadPct."""
import os

BASE = r"c:\Users\Lenovo\Desktop\smartGranjaAves_pro\lib\features\guias_manejo\infrastructure\data"

def gs(sem, luz, alim, peso, agua, tipo, temp, hum):
    return f"  GuiaSemanal(semana: {sem}, luzHoras: {luz}, alimentoGAve: {alim}, pesoObjetivoG: {peso}, aguaMlAve: {agua}, tipoAlimento: '{tipo}', temperaturaC: {temp}, humedadPct: {hum}),"


# ── datos_reproductora_pesada.dart ──
content = """import '../../domain/entities/guia_semanal.dart';

/// Datos basados en manuales Cobb 500 Breeder y Ross 308 PS.
/// Ciclo: 0-60 semanas (levante 0-22, produccion 23-60).
const datosReproductoraPesada = <GuiaSemanal>[
  // === LEVANTE (0-22 semanas) ===
""" + "\n".join([
    gs(0,  22, 18,  150,  36,  'Pre-iniciador', 33, 65),
    gs(1,  20, 25,  250,  50,  'Iniciador',     30, 65),
    gs(2,  18, 35,  400,  70,  'Iniciador',     27, 60),
    gs(3,  14, 45,  560,  90,  'Crecimiento',   25, 60),
    gs(4,  10, 55,  740,  110, 'Crecimiento',   23, 60),
    gs(5,  8,  60,  880,  120, 'Crecimiento',   21, 60),
    gs(6,  8,  65,  1020, 130, 'Crecimiento',   21, 55),
    gs(7,  8,  68,  1160, 136, 'Crecimiento',   21, 55),
    gs(8,  8,  72,  1300, 144, 'Crecimiento',   21, 55),
    gs(9,  8,  76,  1440, 152, 'Crecimiento',   21, 55),
    gs(10, 8,  80,  1570, 160, 'Crecimiento',   21, 55),
    gs(12, 8,  88,  1820, 176, 'Levante',       21, 55),
    gs(14, 8,  96,  2060, 192, 'Levante',       21, 55),
    gs(16, 8,  104, 2300, 208, 'Levante',       21, 55),
    gs(18, 10, 112, 2550, 224, 'Levante',       21, 55),
    gs(20, 12, 120, 2800, 240, 'Pre-postura',   21, 55),
    gs(22, 13, 135, 3050, 270, 'Pre-postura',   21, 55),
    "  // === PRODUCCION (23-60 semanas) ===",
    gs(24, 14, 155, 3300, 310, 'Reproductora',  21, 55),
    gs(26, 15, 160, 3450, 320, 'Reproductora',  21, 55),
    gs(28, 15, 162, 3550, 324, 'Reproductora',  21, 55),
    gs(30, 16, 163, 3650, 326, 'Reproductora',  21, 55),
    gs(35, 16, 160, 3800, 320, 'Reproductora',  21, 55),
    gs(40, 16, 158, 3950, 316, 'Reproductora',  21, 55),
    gs(45, 16, 155, 4100, 310, 'Reproductora',  21, 55),
    gs(50, 16, 152, 4200, 304, 'Reproductora',  21, 55),
    gs(55, 16, 150, 4350, 300, 'Reproductora',  21, 55),
    gs(60, 16, 148, 4500, 296, 'Reproductora',  21, 55),
]) + "\n];\n"
with open(os.path.join(BASE, "datos_reproductora_pesada.dart"), "w", encoding="utf-8") as f:
    f.write(content)
print("✓ reproductora_pesada")


# ── datos_reproductora_liviana.dart ──
content = """import '../../domain/entities/guia_semanal.dart';

/// Datos basados en manuales Lohmann LSL-Classic para reproductora liviana.
/// Ciclo: 0-72 semanas (levante 0-17, pre-postura 18-19, produccion 20-72).
const datosReproductoraLiviana = <GuiaSemanal>[
  // === LEVANTE ===
""" + "\n".join([
    gs(0,  22, 12, 65,   24,  'Pre-iniciador', 33, 65),
    gs(1,  20, 17, 100,  34,  'Iniciador',     30, 65),
    gs(2,  18, 20, 150,  40,  'Iniciador',     27, 60),
    gs(3,  16, 24, 210,  48,  'Iniciador',     25, 60),
    gs(4,  14, 29, 280,  58,  'Levante',       23, 60),
    gs(5,  12, 34, 350,  68,  'Levante',       21, 60),
    gs(6,  10, 39, 420,  78,  'Levante',       21, 55),
    gs(7,  10, 44, 500,  88,  'Levante',       21, 55),
    gs(8,  10, 49, 580,  98,  'Levante',       21, 55),
    gs(9,  10, 53, 660,  106, 'Levante',       21, 55),
    gs(10, 10, 57, 750,  114, 'Levante',       21, 55),
    gs(11, 10, 60, 830,  120, 'Levante',       21, 55),
    gs(12, 10, 63, 910,  126, 'Levante',       21, 55),
    gs(13, 10, 66, 990,  132, 'Levante',       21, 55),
    gs(14, 10, 69, 1065, 138, 'Levante',       21, 55),
    gs(15, 11, 72, 1140, 144, 'Levante',       21, 55),
    gs(16, 12, 75, 1215, 150, 'Levante',       21, 55),
    gs(17, 13, 78, 1280, 156, 'Levante',       21, 55),
    "  // === PRE-POSTURA ===",
    gs(18, 13.5, 85, 1350, 170, 'Pre-postura', 21, 55),
    gs(19, 14,   92, 1420, 184, 'Pre-postura', 21, 55),
    "  // === PRODUCCION ===",
    gs(20, 14.5, 100, 1500, 200, 'Reproductora', 21, 55),
    gs(22, 15,   108, 1600, 216, 'Reproductora', 21, 55),
    gs(24, 15.5, 112, 1700, 224, 'Reproductora', 21, 55),
    gs(26, 16,   114, 1780, 228, 'Reproductora', 21, 55),
    gs(28, 16,   115, 1850, 230, 'Reproductora', 21, 55),
    gs(30, 16,   115, 1900, 230, 'Reproductora', 21, 55),
    gs(35, 16,   114, 1960, 228, 'Reproductora', 21, 55),
    gs(40, 16,   113, 2000, 226, 'Reproductora', 21, 55),
    gs(50, 16,   111, 2050, 222, 'Reproductora', 21, 55),
    gs(60, 16,   109, 2090, 218, 'Reproductora', 21, 55),
    gs(72, 16,   107, 2120, 214, 'Reproductora', 21, 55),
]) + "\n];\n"
with open(os.path.join(BASE, "datos_reproductora_liviana.dart"), "w", encoding="utf-8") as f:
    f.write(content)
print("✓ reproductora_liviana")


# ── datos_pavo.dart ──
content = """import '../../domain/entities/guia_semanal.dart';

/// Datos basados en manuales Nicholas / Hybrid Turkeys para pavo de engorde.
/// Ciclo: 0-12 semanas (hembras) / 0-16 semanas (machos). Usamos mixto.
const datosPavo = <GuiaSemanal>[
""" + "\n".join([
    gs(0,  23, 25,  175,  50,  'Pre-iniciador', 35, 65),
    gs(1,  22, 45,  360,  90,  'Iniciador',     33, 65),
    gs(2,  20, 70,  600,  140, 'Iniciador',     30, 60),
    gs(3,  18, 100, 900,  200, 'Crecimiento',   28, 60),
    gs(4,  16, 130, 1250, 260, 'Crecimiento',   26, 60),
    gs(5,  14, 162, 1700, 324, 'Crecimiento',   24, 55),
    gs(6,  14, 195, 2200, 390, 'Crecimiento',   23, 55),
    gs(7,  14, 225, 2800, 450, 'Engorde',       22, 55),
    gs(8,  14, 260, 3500, 520, 'Engorde',       21, 55),
    gs(9,  14, 290, 4200, 580, 'Engorde',       21, 55),
    gs(10, 14, 320, 5000, 640, 'Engorde',       21, 55),
    gs(11, 14, 340, 5800, 680, 'Engorde',       21, 55),
    gs(12, 14, 360, 6600, 720, 'Engorde',       21, 55),
]) + "\n];\n"
with open(os.path.join(BASE, "datos_pavo.dart"), "w", encoding="utf-8") as f:
    f.write(content)
print("✓ pavo")


# ── datos_codorniz.dart ──
content = """import '../../domain/entities/guia_semanal.dart';

/// Datos basados en referencias Coturnix japonica (codorniz japonesa).
/// Ciclo: 0-36 semanas (levante 0-5, postura 6-36).
const datosCodorniz = <GuiaSemanal>[
  // === LEVANTE ===
""" + "\n".join([
    gs(0, 23, 5,   8,   10,  'Pre-iniciador', 35, 65),
    gs(1, 22, 8,   20,  16,  'Iniciador',     33, 65),
    gs(2, 20, 12,  40,  24,  'Iniciador',     30, 60),
    gs(3, 18, 16,  65,  32,  'Crecimiento',   28, 60),
    gs(4, 16, 20,  95,  40,  'Crecimiento',   26, 60),
    gs(5, 14, 23,  120, 46,  'Crecimiento',   24, 60),
    "  // === POSTURA ===",
    gs(6,  14, 25, 140, 50,  'Postura', 24, 60),
    gs(7,  14, 27, 155, 54,  'Postura', 24, 60),
    gs(8,  14, 28, 165, 56,  'Postura', 24, 60),
    gs(10, 14, 28, 175, 56,  'Postura', 24, 60),
    gs(12, 14, 28, 180, 56,  'Postura', 24, 60),
    gs(16, 14, 28, 185, 56,  'Postura', 24, 60),
    gs(20, 14, 27, 185, 54,  'Postura', 24, 60),
    gs(24, 14, 27, 190, 54,  'Postura', 24, 60),
    gs(28, 14, 26, 190, 52,  'Postura', 24, 60),
    gs(32, 14, 26, 190, 52,  'Postura', 24, 60),
    gs(36, 14, 25, 190, 50,  'Postura', 24, 60),
]) + "\n];\n"
with open(os.path.join(BASE, "datos_codorniz.dart"), "w", encoding="utf-8") as f:
    f.write(content)
print("✓ codorniz")


# ── datos_pato.dart ──
content = """import '../../domain/entities/guia_semanal.dart';

/// Datos basados en manuales Cherry Valley / Pekin duck.
/// Ciclo: 0-8 semanas de engorde.
const datosPato = <GuiaSemanal>[
""" + "\n".join([
    gs(0, 23, 20,  80,   40,  'Pre-iniciador', 30, 70),
    gs(1, 22, 45,  250,  90,  'Iniciador',     28, 65),
    gs(2, 20, 80,  550,  160, 'Iniciador',     26, 65),
    gs(3, 18, 120, 950,  240, 'Crecimiento',   24, 60),
    gs(4, 16, 155, 1400, 310, 'Crecimiento',   22, 60),
    gs(5, 14, 185, 1900, 370, 'Engorde',       20, 60),
    gs(6, 14, 210, 2400, 420, 'Engorde',       19, 60),
    gs(7, 14, 230, 2900, 460, 'Engorde',       18, 60),
    gs(8, 14, 240, 3300, 480, 'Engorde',       18, 60),
]) + "\n];\n"
with open(os.path.join(BASE, "datos_pato.dart"), "w", encoding="utf-8") as f:
    f.write(content)
print("✓ pato")


# ── datos_otro.dart ──
content = """import '../../domain/entities/guia_semanal.dart';

/// Datos genericos basados en pollo de engorde estandar.
/// Util como referencia para aves sin guia especifica.
const datosOtro = <GuiaSemanal>[
""" + "\n".join([
    gs(0, 23, 15,  42,   30,  'Pre-iniciador', 33, 65),
    gs(1, 22, 30,  160,  60,  'Iniciador',     30, 65),
    gs(2, 20, 55,  400,  110, 'Iniciador',     27, 60),
    gs(3, 18, 85,  730,  170, 'Crecimiento',   24, 60),
    gs(4, 16, 120, 1150, 240, 'Crecimiento',   22, 55),
    gs(5, 14, 155, 1650, 310, 'Engorde',       20, 55),
    gs(6, 14, 175, 2200, 350, 'Engorde',       20, 55),
]) + "\n];\n"
with open(os.path.join(BASE, "datos_otro.dart"), "w", encoding="utf-8") as f:
    f.write(content)
print("✓ otro")

print("\n✅ All 6 data files updated with temperaturaC and humedadPct!")
