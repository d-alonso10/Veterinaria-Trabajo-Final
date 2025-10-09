package modelo;

public class MetricasDashboardDTO {
    private int totalClientes;
    private int totalMascotas;
    private int citasHoy;
    private double ingresosMes;
    private int atencionesCurso;

    public MetricasDashboardDTO() {}

    public MetricasDashboardDTO(int totalClientes, int totalMascotas, int citasHoy, double ingresosMes, int atencionesCurso) {
        this.totalClientes = totalClientes;
        this.totalMascotas = totalMascotas;
        this.citasHoy = citasHoy;
        this.ingresosMes = ingresosMes;
        this.atencionesCurso = atencionesCurso;
    }

    // Getters y Setters
    public int getTotalClientes() { return totalClientes; }
    public void setTotalClientes(int totalClientes) { this.totalClientes = totalClientes; }
    public int getTotalMascotas() { return totalMascotas; }
    public void setTotalMascotas(int totalMascotas) { this.totalMascotas = totalMascotas; }
    public int getCitasHoy() { return citasHoy; }
    public void setCitasHoy(int citasHoy) { this.citasHoy = citasHoy; }
    public double getIngresosMes() { return ingresosMes; }
    public void setIngresosMes(double ingresosMes) { this.ingresosMes = ingresosMes; }
    public int getAtencionesCurso() { return atencionesCurso; }
    public void setAtencionesCurso(int atencionesCurso) { this.atencionesCurso = atencionesCurso; }
}