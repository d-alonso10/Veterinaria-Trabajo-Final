package modelo;

import java.sql.Timestamp;

public class AuditLog {
    private int idLog;
    private String entidad;
    private int entidadId;
    private String accion;
    private int idUsuario;
    private String antes;
    private String despues;
    private java.sql.Timestamp timestamp;

    public AuditLog() {}

    public AuditLog(int idLog, String entidad, int entidadId, String accion, int idUsuario, String antes, String despues, java.sql.Timestamp timestamp) {
        this.idLog = idLog;
        this.entidad = entidad;
        this.entidadId = entidadId;
        this.accion = accion;
        this.idUsuario = idUsuario;
        this.antes = antes;
        this.despues = despues;
        this.timestamp = timestamp;
    }

    public int getIdLog() { return idLog; }
    public void setIdLog(int idLog) { this.idLog = idLog; }
    public String getEntidad() { return entidad; }
    public void setEntidad(String entidad) { this.entidad = entidad; }
    public int getEntidadId() { return entidadId; }
    public void setEntidadId(int entidadId) { this.entidadId = entidadId; }
    public String getAccion() { return accion; }
    public void setAccion(String accion) { this.accion = accion; }
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    public String getAntes() { return antes; }
    public void setAntes(String antes) { this.antes = antes; }
    public String getDespues() { return despues; }
    public void setDespues(String despues) { this.despues = despues; }
    public java.sql.Timestamp getTimestamp() { return timestamp; }
    public void setTimestamp(java.sql.Timestamp timestamp) { this.timestamp = timestamp; }
}
