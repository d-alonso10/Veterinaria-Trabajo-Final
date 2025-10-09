package modelo;

public class GroomerDisponibilidadDTO {
    private int idGroomer;
    private String nombre;
    private String disponibilidad;
    private int atencionesProgramadas;

    public GroomerDisponibilidadDTO() {}

    public GroomerDisponibilidadDTO(int idGroomer, String nombre, String disponibilidad, int atencionesProgramadas) {
        this.idGroomer = idGroomer;
        this.nombre = nombre;
        this.disponibilidad = disponibilidad;
        this.atencionesProgramadas = atencionesProgramadas;
    }

    public int getIdGroomer() { return idGroomer; }
    public void setIdGroomer(int idGroomer) { this.idGroomer = idGroomer; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getDisponibilidad() { return disponibilidad; }
    public void setDisponibilidad(String disponibilidad) { this.disponibilidad = disponibilidad; }
    public int getAtencionesProgramadas() { return atencionesProgramadas; }
    public void setAtencionesProgramadas(int atencionesProgramadas) { this.atencionesProgramadas = atencionesProgramadas; }
}