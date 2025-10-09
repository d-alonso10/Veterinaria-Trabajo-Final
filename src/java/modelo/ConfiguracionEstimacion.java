package modelo;

public class ConfiguracionEstimacion {
    private int idConfig;
    private int idServicio;
    private int idGroomer;
    private int tiempoEstimadoMin;

    public ConfiguracionEstimacion() {}

    public ConfiguracionEstimacion(int idConfig, int idServicio, int idGroomer, int tiempoEstimadoMin) {
        this.idConfig = idConfig;
        this.idServicio = idServicio;
        this.idGroomer = idGroomer;
        this.tiempoEstimadoMin = tiempoEstimadoMin;
    }

    public int getIdConfig() { return idConfig; }
    public void setIdConfig(int idConfig) { this.idConfig = idConfig; }
    public int getIdServicio() { return idServicio; }
    public void setIdServicio(int idServicio) { this.idServicio = idServicio; }
    public int getIdGroomer() { return idGroomer; }
    public void setIdGroomer(int idGroomer) { this.idGroomer = idGroomer; }
    public int getTiempoEstimadoMin() { return tiempoEstimadoMin; }
    public void setTiempoEstimadoMin(int tiempoEstimadoMin) { this.tiempoEstimadoMin = tiempoEstimadoMin; }
}
