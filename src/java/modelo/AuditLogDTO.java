package modelo;

import java.sql.Timestamp;

public class AuditLogDTO {
    private String entidad;
    private int entidadId;
    private String accion;
    private String usuario;
    private Timestamp timestamp;
    private String antes;
    private String despues;

    // Getters y Setters
    public String getEntidad() { return entidad; }
    public void setEntidad(String entidad) { this.entidad = entidad; }
    public int getEntidadId() { return entidadId; }
    public void setEntidadId(int entidadId) { this.entidadId = entidadId; }
    public String getAccion() { return accion; }
    public void setAccion(String accion) { this.accion = accion; }
    public String getUsuario() { return usuario; }
    public void setUsuario(String usuario) { this.usuario = usuario; }
    public Timestamp getTimestamp() { return timestamp; }
    public void setTimestamp(Timestamp timestamp) { this.timestamp = timestamp; }
    public String getAntes() { return antes; }
    public void setAntes(String antes) { this.antes = antes; }
    public String getDespues() { return despues; }
    public void setDespues(String despues) { this.despues = despues; }
}