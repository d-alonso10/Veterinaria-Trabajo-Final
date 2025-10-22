package modelo;

import java.sql.Timestamp;

public class Notificacion {
    private int idNotificacion;
    private String tipo;
    private int destinatarioId;
    private String canal;
    private String contenido;
    private java.sql.Timestamp fechaCreacion;  // Campo fecha_creacion de la BD
    private java.sql.Timestamp enviadoAt;
    private String estado;
    private String referenciaTipo;
    private int referenciaId;

    public Notificacion() {}

    public Notificacion(int idNotificacion, String tipo, int destinatarioId, String canal, String contenido, java.sql.Timestamp fechaCreacion, java.sql.Timestamp enviadoAt, String estado, String referenciaTipo, int referenciaId) {
        this.idNotificacion = idNotificacion;
        this.tipo = tipo;
        this.destinatarioId = destinatarioId;
        this.canal = canal;
        this.contenido = contenido;
        this.fechaCreacion = fechaCreacion;
        this.enviadoAt = enviadoAt;
        this.estado = estado;
        this.referenciaTipo = referenciaTipo;
        this.referenciaId = referenciaId;
    }

    public int getIdNotificacion() { return idNotificacion; }
    public void setIdNotificacion(int idNotificacion) { this.idNotificacion = idNotificacion; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public int getDestinatarioId() { return destinatarioId; }
    public void setDestinatarioId(int destinatarioId) { this.destinatarioId = destinatarioId; }
    public String getCanal() { return canal; }
    public void setCanal(String canal) { this.canal = canal; }
    public String getContenido() { return contenido; }
    public void setContenido(String contenido) { this.contenido = contenido; }
    public java.sql.Timestamp getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(java.sql.Timestamp fechaCreacion) { this.fechaCreacion = fechaCreacion; }
    public java.sql.Timestamp getEnviadoAt() { return enviadoAt; }
    public void setEnviadoAt(java.sql.Timestamp enviadoAt) { this.enviadoAt = enviadoAt; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getReferenciaTipo() { return referenciaTipo; }
    public void setReferenciaTipo(String referenciaTipo) { this.referenciaTipo = referenciaTipo; }
    public int getReferenciaId() { return referenciaId; }
    public void setReferenciaId(int referenciaId) { this.referenciaId = referenciaId; }
}