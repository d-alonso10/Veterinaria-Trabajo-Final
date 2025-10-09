package modelo;

import java.sql.Timestamp;

public class CitaDTO {
    private int idCita;
    private Timestamp fechaProgramada;
    private String estado;
    private String nombreServicio;
    // Puedes agregar más campos si necesitas
    
    public CitaDTO() {}

    public CitaDTO(int idCita, Timestamp fechaProgramada, String estado, String nombreServicio) {
        this.idCita = idCita;
        this.fechaProgramada = fechaProgramada;
        this.estado = estado;
        this.nombreServicio = nombreServicio;
    }

    // Getters y Setters
    public int getIdCita() { return idCita; }
    public void setIdCita(int idCita) { this.idCita = idCita; }
    public Timestamp getFechaProgramada() { return fechaProgramada; }
    public void setFechaProgramada(Timestamp fechaProgramada) { this.fechaProgramada = fechaProgramada; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getNombreServicio() { return nombreServicio; }
    public void setNombreServicio(String nombreServicio) { this.nombreServicio = nombreServicio; }
}