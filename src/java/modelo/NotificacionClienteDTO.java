package modelo;

import java.sql.Timestamp;

public class NotificacionClienteDTO {
    private String tipo;
    private String contenido;
    private Timestamp enviadoAt;
    private String estado;
    private String referenciaTipo;
    private int referenciaId;

    // Getters y Setters
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public String getContenido() { return contenido; }
    public void setContenido(String contenido) { this.contenido = contenido; }
    public Timestamp getEnviadoAt() { return enviadoAt; }
    public void setEnviadoAt(Timestamp enviadoAt) { this.enviadoAt = enviadoAt; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getReferenciaTipo() { return referenciaTipo; }
    public void setReferenciaTipo(String referenciaTipo) { this.referenciaTipo = referenciaTipo; }
    public int getReferenciaId() { return referenciaId; }
    public void setReferenciaId(int referenciaId) { this.referenciaId = referenciaId; }
}