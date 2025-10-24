<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.OcupacionGroomerDTO, java.sql.Date" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocupación de Groomers - Sistema PetCare</title>
    <style>
        :root {
            --primary-color: #abcbd5;
            --primary-dark: #8fb6c1;
            --primary-light: #c5dce3;
            --secondary-color: #d5c4ad;
            --accent-color: #d5adc7;
            --success-color: #4CAF50;
            --warning-color: #FFC107;
            --danger-color: #F44336;
            --info-color: #2196F3;
            --text-dark: #2c3e50;
            --text-light: #5d6d7e;
            --bg-light: #f8f9fa;
            --white: #ffffff;
            --shadow: 0 8px 32px rgba(0,0,0,0.1);
            --radius: 16px;
            --gradient-primary: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            --gradient-success: linear-gradient(135deg, var(--success-color) 0%, #45a049 100%);
            --gradient-warning: linear-gradient(135deg, var(--warning-color) 0%, #ffb300 100%);
            --gradient-danger: linear-gradient(135deg, var(--danger-color) 0%, #d32f2f 100%);
            --gradient-info: linear-gradient(135deg, var(--info-color) 0%, #0b7dda 100%);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, var(--primary-light) 100%);
            color: var(--text-dark);
            line-height: 1.6;
            min-height: 100vh;
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background: var(--gradient-primary);
            color: var(--white);
            padding: 0;
            box-shadow: var(--shadow);
            position: relative;
            z-index: 10;
        }

        .logo {
            padding: 30px 20px;
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .logo h1 {
            font-size: 1.8em;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .logo-icon {
            font-size: 2em;
        }

        .user-info {
            padding: 25px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.05);
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2em;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .user-details h3 {
            font-size: 1.1em;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .user-details p {
            font-size: 0.85em;
            opacity: 0.9;
        }

        .menu {
            list-style: none;
            padding: 25px 0;
        }

        .menu-section {
            padding: 15px 25px;
            font-size: 0.75em;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.7);
            letter-spacing: 1.5px;
            margin-top: 15px;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.05);
        }

        .menu-item {
            padding: 16px 30px;
            border-left: 4px solid transparent;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
            overflow: hidden;
        }

        .menu-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.6s;
        }

        .menu-item:hover::before {
            left: 100%;
        }

        .menu-item:hover {
            background-color: rgba(255, 255, 255, 0.1);
            border-left-color: var(--white);
            transform: translateX(5px);
        }

        .menu-item.active {
            background-color: rgba(255, 255, 255, 0.15);
            border-left-color: var(--white);
        }

        .menu-item a {
            color: var(--white);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 15px;
            width: 100%;
            font-size: 0.95em;
            font-weight: 500;
        }

        .menu-icon {
            font-size: 1.3em;
            width: 24px;
            text-align: center;
        }

        /* Main Content Styles */
        .content {
            flex: 1;
            padding: 0;
            background: transparent;
            overflow-y: auto;
        }

        .header {
            background: var(--white);
            padding: 25px 40px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--gradient-primary);
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .welcome h1 {
            font-size: 2.2em;
            color: var(--text-dark);
            margin-bottom: 8px;
            font-weight: 700;
        }

        .welcome p {
            color: var(--text-light);
            font-size: 1.1em;
            font-weight: 500;
        }

        .header-actions {
            display: flex;
            gap: 15px;
        }

        .main-content {
            padding: 40px;
            max-width: 1400px;
            margin: 0 auto;
        }

        /* Botones */
        .btn {
            padding: 16px 28px;
            border: none;
            border-radius: var(--radius);
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 0.95em;
            position: relative;
            overflow: hidden;
            border: 1px solid transparent;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(171, 203, 213, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(171, 203, 213, 0.4);
        }

        .btn-success {
            background: var(--gradient-success);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(76, 175, 80, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(76, 175, 80, 0.4);
        }

        .btn-warning {
            background: var(--gradient-warning);
            color: var(--text-dark);
            box-shadow: 0 8px 25px rgba(255, 193, 7, 0.3);
        }

        .btn-warning:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(255, 193, 7, 0.4);
        }

        .btn-info {
            background: var(--gradient-info);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(33, 150, 243, 0.3);
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(33, 150, 243, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--secondary-color) 0%, #c9b18c 100%);
            color: var(--text-dark);
            box-shadow: 0 8px 25px rgba(213, 196, 173, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(213, 196, 173, 0.4);
        }

        .btn-small {
            padding: 12px 20px;
            font-size: 0.9em;
        }

        /* Date Filter */
        .date-filter {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border-top: 4px solid var(--primary-color);
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .filter-form {
            display: flex;
            gap: 20px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        .form-group {
            flex: 1;
            min-width: 250px;
        }

        .form-group label {
            display: block;
            margin-bottom: 12px;
            font-weight: 600;
            color: var(--text-dark);
            font-size: 1.1em;
        }

        .form-control {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e0e0e0;
            border-radius: var(--radius);
            font-size: 1em;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            background-color: var(--white);
            box-shadow: 0 0 0 4px rgba(171, 203, 213, 0.2);
            transform: translateY(-2px);
        }

        /* Stats Container */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin: 30px 0;
        }

        .stat-card {
            background: var(--white);
            padding: 30px 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            text-align: center;
            border: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .stat-icon {
            font-size: 3em;
            margin-bottom: 15px;
            display: block;
        }

        .stat-number {
            font-size: 2.5em;
            font-weight: 800;
            margin: 10px 0;
            color: var(--primary-dark);
        }

        .stat-label {
            color: var(--text-light);
            font-size: 1em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .stat-ocupacion .stat-icon { color: var(--info-color); }
        .stat-atenciones .stat-icon { color: var(--success-color); }
        .stat-tiempo .stat-icon { color: var(--warning-color); }
        .stat-groomers .stat-icon { color: var(--primary-color); }

        /* Period Info */
        .period-info {
            background: var(--white);
            padding: 25px 30px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border-left: 4px solid var(--info-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            animation: fadeInUp 0.7s ease-out;
        }

        .period-date {
            font-size: 1.2em;
            font-weight: 600;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .period-stats {
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .stat-badge {
            background: linear-gradient(135deg, #e8f4f8 0%, #d4eaf0 100%);
            color: var(--text-dark);
            padding: 10px 18px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.95em;
            border: 1px solid var(--primary-light);
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .stat-badge:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(171, 203, 213, 0.3);
        }

        /* Table Container */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            animation: fadeInUp 0.8s ease-out;
        }

        .table-wrapper {
            overflow-x: auto;
            border-radius: var(--radius);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }

        th {
            background: var(--gradient-primary);
            color: var(--white);
            font-weight: 600;
            padding: 20px;
            text-align: left;
            border-bottom: 2px solid var(--primary-dark);
            position: sticky;
            top: 0;
            font-size: 0.95em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            font-size: 0.95em;
        }

        tr {
            transition: all 0.3s ease;
        }

        tr:hover td {
            background-color: rgba(171, 203, 213, 0.05);
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        /* Groomer Info */
        .groomer-name {
            font-weight: 600;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.05em;
        }

        .atenciones-badge {
            background: linear-gradient(135deg, #e8f5e8 0%, #d4edda 100%);
            color: var(--text-dark);
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9em;
            border: 1px solid #c3e6cb;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
        }

        .atenciones-badge:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }

        .tiempo-badge {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            color: #856404;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9em;
            border: 1px solid #ffeaa7;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
        }

        .tiempo-badge:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
        }

        /* Progress Bars */
        .ocupacion-progress {
            width: 100%;
            height: 10px;
            background: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            margin: 10px 0;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
        }

        .ocupacion-progress-bar {
            height: 100%;
            border-radius: 10px;
            transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .ocupacion-progress-bar::after {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
            animation: shimmer 2s infinite;
        }

        @keyframes shimmer {
            0% { left: -100%; }
            100% { left: 100%; }
        }

        .ocupacion-baja { 
            background: linear-gradient(90deg, var(--success-color), #51cf66); 
        }
        .ocupacion-media { 
            background: linear-gradient(90deg, var(--warning-color), #ffd43b); 
        }
        .ocupacion-alta { 
            background: linear-gradient(90deg, var(--danger-color), #ff6b6b); 
        }

        .ocupacion-indicator {
            display: flex;
            align-items: center;
            gap: 15px;
            font-weight: 600;
        }

        .ocupacion-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85em;
            text-align: center;
            min-width: 100px;
            transition: all 0.3s ease;
        }

        .ocupacion-badge:hover {
            transform: scale(1.05);
        }

        .ocupacion-optima { 
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border: 1px solid #b1dfbb;
        }
        .ocupacion-moderada { 
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            color: #856404;
            border: 1px solid #ffdf7e;
        }
        .ocupacion-alta-badge { 
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border: 1px solid #f1b0b7;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-light);
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin: 30px 0;
            animation: fadeInUp 0.8s ease-out;
        }

        .empty-state-icon {
            font-size: 4em;
            margin-bottom: 20px;
            display: block;
            opacity: 0.7;
        }

        .empty-state h3 {
            font-size: 1.8em;
            margin-bottom: 15px;
            color: var(--text-dark);
            font-weight: 600;
        }

        .empty-state p {
            font-size: 1.1em;
            margin-bottom: 30px;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.8;
        }

        /* Navigation */
        .navigation {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 40px 0;
        }

        .navigation .btn {
            width: 100%;
            justify-content: center;
            padding: 20px;
            font-size: 1em;
        }

        /* Mensajes de estado */
        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            border-left: 4px solid;
            font-size: 1em;
            box-shadow: var(--shadow);
            animation: slideInDown 0.5s ease-out;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .exito {
            background: linear-gradient(135deg, #f0f9f4 0%, #e8f5e8 100%);
            border-left-color: var(--success-color);
            color: #1e7e34;
        }

        .error {
            background: linear-gradient(135deg, #fdf2f2 0%, #fde8e8 100%);
            border-left-color: var(--danger-color);
            color: #c53030;
        }

        .info {
            background: linear-gradient(135deg, #f0f7ff 0%, #e6f3ff 100%);
            border-left-color: var(--info-color);
            color: var(--text-dark);
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .container {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                height: auto;
            }
            .menu {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                padding: 15px;
            }
            .menu-item {
                flex: 1 0 200px;
                justify-content: center;
            }
            .menu-section {
                display: none;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 20px;
            }
            .header-top {
                flex-direction: column;
                gap: 20px;
                align-items: flex-start;
            }
            .header-actions {
                width: 100%;
                justify-content: center;
            }
            .filter-form {
                flex-direction: column;
                gap: 15px;
            }
            .period-info {
                flex-direction: column;
                text-align: center;
            }
            .period-stats {
                justify-content: center;
            }
            .stats-container {
                grid-template-columns: 1fr;
            }
            .navigation {
                grid-template-columns: 1fr;
            }
            .ocupacion-indicator {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
            .date-filter {
                padding: 20px;
            }
            .empty-state {
                padding: 40px 20px;
            }
            .empty-state-icon {
                font-size: 3em;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
        }

        /* Efectos especiales */
        .floating {
            animation: floating 3s ease-in-out infinite;
        }

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .loading-dots {
            display: inline-flex;
            gap: 4px;
        }

        .loading-dots span {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--primary-color);
            animation: loading 1.4s infinite ease-in-out;
        }

        .loading-dots span:nth-child(1) { animation-delay: -0.32s; }
        .loading-dots span:nth-child(2) { animation-delay: -0.16s; }

        @keyframes loading {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }

        .fade-in-row {
            animation: fadeInRow 0.6s ease-out;
        }

        @keyframes fadeInRow {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar Menu -->
        <div class="sidebar">
            <div class="logo">
                <h1><span class="logo-icon">🐕</span> Terán Vet</h1>
            </div>
            
            <div class="user-info">
                <div class="user-avatar">JS</div>
                <div class="user-details">
                    <h3>Juan Sánchez</h3>
                    <p>Administrador</p>
                </div>
            </div>
            
            <ul class="menu">
                <!-- Núcleo del Negocio -->
                <li class="menu-section">Núcleo del Negocio</li>
                <li class="menu-item">
                    <a href="dashboard.jsp">
                        <span class="menu-icon">📊</span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="CitaControlador?accion=todasCitas">
                        <span class="menu-icon">📅</span>
                        <span>Citas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="AtencionControlador">
                        <span class="menu-icon">🎯</span>
                        <span>Atención</span>
                    </a>
                </li>
                
                <!-- Gestión de Clientes -->
                <li class="menu-section">Gestión de Clientes</li>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/ClienteControlador?accion=listarTodos">
                        <span class="menu-icon">👥</span>
                        <span>Clientes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="<%= request.getContextPath() %>/MascotaControlador?accion=listarTodas">
                        <span class="menu-icon">🐾</span>
                        <span>Mascotas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ServicioControlador">
                        <span class="menu-icon">🛠️</span>
                        <span>Servicios</span>
                    </a>
                </li>
                
                <!-- Personal y Operaciones -->
                <li class="menu-section">Personal y Operaciones</li>
                <li class="menu-item active">
                    <a href="GroomerControlador">
                        <span class="menu-icon">✂️</span>
                        <span>Groomers</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="SucursalControlador?accion=listar">
                        <span class="menu-icon">🏢</span>
                        <span>Sucursales</span>
                    </a>
                </li>
                
                <!-- Finanzas -->
                <li class="menu-section">Finanzas</li>
                <li class="menu-item">
                    <a href="pagos.jsp">
                        <span class="menu-icon">💳</span>
                        <span>Pagos</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="facturas.jsp">
                        <span class="menu-icon">🧾</span>
                        <span>Facturas</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="promociones.jsp">
                        <span class="menu-icon">🎁</span>
                        <span>Promociones</span>
                    </a>
                </li>
                
                <!-- Análisis y Control -->
                <li class="menu-section">Análisis y Control</li>
                <li class="menu-item">
                    <a href="ReporteControlador">
                        <span class="menu-icon">📈</span>
                        <span>Reportes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="AuditControlador?accion=listar">
                        <span class="menu-icon">🔍</span>
                        <span>Auditoria</span>
                    </a>
                </li>
                
                <!-- Sistema -->
                <li class="menu-section">Sistema</li>
                <li class="menu-item">
                    <a href="ConfiguracionControlador?accion=listar">
                        <span class="menu-icon">⚙️</span>
                        <span>Configuración</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="content">
            <div class="header">
                <div class="header-top">
                    <div class="welcome">
                        <h1>📊 Análisis de Ocupación</h1>
                        <p>Monitoreo de productividad y utilización del personal de grooming</p>
                    </div>
                    <div class="header-actions">
                        <a href="GroomerControlador" class="btn btn-secondary">
                            <span>← Volver a Groomers</span>
                        </a>
                        <a href="dashboard.jsp" class="btn btn-primary">
                            <span>📊 Ir al Dashboard</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje error">
                        <%= request.getAttribute("mensaje") %>
                    </div>
                <% } %>

                <!-- Filtro de fecha -->
                <div class="date-filter">
                    <form action="GroomerControlador" method="GET" id="filterForm">
                        <input type="hidden" name="accion" value="ocupacion">
                        <div class="filter-form">
                            <div class="form-group">
                                <label for="fecha">📅 Seleccionar Fecha de Análisis:</label>
                                <input type="date" id="fecha" name="fecha" class="form-control" 
                                       value="<%= request.getAttribute("fechaConsulta") != null ? request.getAttribute("fechaConsulta") : "" %>"
                                       onchange="document.getElementById('filterForm').submit()">
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <span>🔍 Consultar Ocupación</span>
                            </button>
                            <button type="button" class="btn btn-success" onclick="establecerFechaHoy()">
                                <span>🔄 Fecha de Hoy</span>
                            </button>
                        </div>
                    </form>
                </div>

                <%
                    List<OcupacionGroomerDTO> ocupaciones = (List<OcupacionGroomerDTO>) request.getAttribute("ocupaciones");
                    Integer totalRegistros = (Integer) request.getAttribute("totalRegistros");
                    Date fechaConsulta = (Date) request.getAttribute("fechaConsulta");
                    
                    // Calcular estadísticas
                    double ocupacionPromedio = 0;
                    int totalAtenciones = 0;
                    int totalMinutos = 0;
                    int groomersOptimos = 0;
                    int groomersModerados = 0;
                    int groomersAltos = 0;
                    int totalGroomersActivos = 0;
                    
                    if (ocupaciones != null && !ocupaciones.isEmpty()) {
                        totalGroomersActivos = ocupaciones.size();
                        
                        for (OcupacionGroomerDTO ocupacion : ocupaciones) {
                            ocupacionPromedio += ocupacion.getPorcentajeOcupacion();
                            totalAtenciones += ocupacion.getAtencionesRealizadas();
                            totalMinutos += ocupacion.getMinutosTrabajados();
                            
                            if (ocupacion.getPorcentajeOcupacion() <= 50) groomersOptimos++;
                            else if (ocupacion.getPorcentajeOcupacion() <= 80) groomersModerados++;
                            else groomersAltos++;
                        }
                        ocupacionPromedio = ocupacionPromedio / totalGroomersActivos;
                    }
                %>

                <!-- Información del período -->
                <% if (fechaConsulta != null) { %>
                    <div class="period-info">
                        <div class="period-date">
                            <span>📅</span>
                            <div>
                                <strong>Período Analizado:</strong><br>
                                <span style="font-size: 1.1em; color: var(--primary-dark);">
                                    <%= fechaConsulta %>
                                </span>
                            </div>
                        </div>
                        <div class="period-stats">
                            <span class="stat-badge">
                                👥 Groomers Activos: <strong><%= totalGroomersActivos %></strong>
                            </span>
                            <span class="stat-badge">
                                ✅ Total Atenciones: <strong><%= totalAtenciones %></strong>
                            </span>
                            <span class="stat-badge">
                                ⏱️ Horas Trabajadas: <strong><%= String.format("%.1f", totalMinutos / 60.0) %></strong>
                            </span>
                        </div>
                    </div>
                <% } %>

                <!-- Estadísticas generales -->
                <% if (ocupaciones != null && !ocupaciones.isEmpty()) { %>
                    <div class="stats-container">
                        <div class="stat-card stat-ocupacion floating">
                            <span class="stat-icon">📈</span>
                            <div class="stat-number"><%= String.format("%.1f", ocupacionPromedio) %>%</div>
                            <div class="stat-label">Ocupación Promedio</div>
                        </div>
                        
                        <div class="stat-card stat-atenciones floating" style="animation-delay: 0.2s;">
                            <span class="stat-icon">✅</span>
                            <div class="stat-number"><%= totalAtenciones %></div>
                            <div class="stat-label">Total Atenciones</div>
                        </div>
                        
                        <div class="stat-card stat-tiempo floating" style="animation-delay: 0.4s;">
                            <span class="stat-icon">⏱️</span>
                            <div class="stat-number"><%= String.format("%.1f", totalMinutos / 60.0) %>h</div>
                            <div class="stat-label">Horas Trabajadas</div>
                        </div>
                        
                        <div class="stat-card stat-groomers floating" style="animation-delay: 0.6s;">
                            <span class="stat-icon">👥</span>
                            <div class="stat-number"><%= totalGroomersActivos %></div>
                            <div class="stat-label">Groomers Activos</div>
                        </div>
                    </div>

                    <!-- Distribución de ocupación -->
                    <div class="stats-container">
                        <div class="stat-card" style="border-top-color: var(--success-color);">
                            <span class="stat-icon">🟢</span>
                            <div class="stat-number"><%= groomersOptimos %></div>
                            <div class="stat-label">Óptima Ocupación</div>
                        </div>
                        
                        <div class="stat-card" style="border-top-color: var(--warning-color);">
                            <span class="stat-icon">🟡</span>
                            <div class="stat-number"><%= groomersModerados %></div>
                            <div class="stat-label">Moderada Ocupación</div>
                        </div>
                        
                        <div class="stat-card" style="border-top-color: var(--danger-color);">
                            <span class="stat-icon">🔴</span>
                            <div class="stat-number"><%= groomersAltos %></div>
                            <div class="stat-label">Alta Ocupación</div>
                        </div>
                        
                        <div class="stat-card" style="border-top-color: var(--info-color);">
                            <span class="stat-icon">📊</span>
                            <div class="stat-number">
                                <%= totalGroomersActivos > 0 ? String.format("%.0f", groomersOptimos * 100.0 / totalGroomersActivos) : 0 %>%
                            </div>
                            <div class="stat-label">Eficiencia General</div>
                        </div>
                    </div>

                <% } %>

                <!-- Tabla de ocupación -->
                <h3 style="margin: 30px 0 20px 0; color: var(--text-dark); font-size: 1.4em; display: flex; align-items: center; gap: 10px;">
                    <span>👥</span> Desempeño Detallado por Groomer
                    <% if (totalRegistros != null && totalRegistros > 0) { %>
                        <span style="color: var(--text-light); font-size: 16px; font-weight: 500;">
                            (<%= totalRegistros %> groomers encontrados)
                        </span>
                    <% } %>
                </h3>

                <% if (ocupaciones != null && !ocupaciones.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Groomer</th>
                                        <th>Atenciones Realizadas</th>
                                        <th>Tiempo Trabajado</th>
                                        <th>Nivel de Ocupación</th>
                                        <th>Eficiencia</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (OcupacionGroomerDTO ocupacion : ocupaciones) { 
                                        String nivelOcupacion = obtenerNivelOcupacion(ocupacion.getPorcentajeOcupacion());
                                        String claseOcupacion = obtenerClaseOcupacion(ocupacion.getPorcentajeOcupacion());
                                        String textoOcupacion = obtenerTextoOcupacion(ocupacion.getPorcentajeOcupacion());
                                        String colorPorcentaje = obtenerColorPorcentaje(ocupacion.getPorcentajeOcupacion());
                                        double eficiencia = ocupacion.getMinutosTrabajados() > 0 ? 
                                            (ocupacion.getAtencionesRealizadas() * 60.0) / ocupacion.getMinutosTrabajados() : 0;
                                    %>
                                        <tr class="fade-in-row">
                                            <td>
                                                <div class="groomer-name">
                                                    <span>✂️</span>
                                                    <div>
                                                        <strong><%= ocupacion.getNombreGroomer() %></strong>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="atenciones-badge">
                                                    ✅ <%= ocupacion.getAtencionesRealizadas() %> atenciones
                                                </span>
                                            </td>
                                            <td>
                                                <span class="tiempo-badge">
                                                    ⏱️ <%= ocupacion.getMinutosTrabajados() %> min
                                                    <br>
                                                    <small>(<%= String.format("%.1f", ocupacion.getMinutosTrabajados() / 60.0) %>h)</small>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="ocupacion-indicator">
                                                    <div class="ocupacion-progress">
                                                        <div class="ocupacion-progress-bar <%= nivelOcupacion %>" 
                                                             style="width: <%= Math.min(ocupacion.getPorcentajeOcupacion(), 100) %>%;"
                                                             data-percent="<%= String.format("%.1f", ocupacion.getPorcentajeOcupacion()) %>"></div>
                                                    </div>
                                                    <span class="ocupacion-badge <%= claseOcupacion %>">
                                                        <%= textoOcupacion %>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div style="text-align: center;">
                                                    <strong style="color: <%= colorPorcentaje %>; font-size: 1.1em;">
                                                        <%= String.format("%.1f", ocupacion.getPorcentajeOcupacion()) %>%
                                                    </strong>
                                                    <br>
                                                    <small style="color: var(--text-light);">
                                                        <%= String.format("%.1f", eficiencia) %> atenciones/hora
                                                    </small>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Resumen de análisis -->
                    <div class="info" style="margin: 20px 0; padding: 20px;">
                        <strong>📋 Resumen del Análisis:</strong><br>
                        • <strong><%= totalGroomersActivos %></strong> groomers activos analizados<br>
                        • Ocupación promedio: <strong><%= String.format("%.1f", ocupacionPromedio) %>%</strong><br>
                        • Total de atenciones: <strong><%= totalAtenciones %></strong><br>
                        • Tiempo total trabajado: <strong><%= String.format("%.1f", totalMinutos / 60.0) %> horas</strong><br>
                        • Eficiencia general: <strong><%= String.format("%.1f", totalAtenciones > 0 ? (totalMinutos / 60.0) / totalAtenciones : 0) %> horas/atención</strong>
                    </div>

                <% } else { %>
                    <div class="empty-state">
                        <span class="empty-state-icon">📊</span>
                        <h3>No hay datos de ocupación disponibles</h3>
                        <p>
                            <% if (fechaConsulta != null) { %>
                                No se encontraron registros de ocupación para la fecha <strong><%= fechaConsulta %></strong>.
                                Esto puede significar que no hubo actividades de grooming programadas para ese día.
                            <% } else { %>
                                Selecciona una fecha específica para analizar la ocupación y productividad de los groomers.
                                Los datos mostrados te ayudarán a optimizar la asignación de recursos y mejorar la eficiencia.
                            <% } %>
                        </p>
                        <div style="display: flex; gap: 15px; justify-content: center; flex-wrap: wrap; margin-top: 20px;">
                            <button type="button" class="btn btn-primary" onclick="establecerFechaHoy()">
                                <span>🔄 Consultar Ocupación de Hoy</span>
                            </button>
                            <a href="GroomerControlador" class="btn btn-secondary">
                                <span>✂️ Gestionar Groomers</span>
                            </a>
                            <a href="CitaControlador?accion=todasCitas" class="btn btn-info">
                                <span>📅 Ver Agenda de Citas</span>
                            </a>
                        </div>
                    </div>
                <% } %>

                <!-- Navegación -->
                <div class="navigation">
                    <a href="GroomerControlador" class="btn btn-secondary">
                        <span>← Volver a Groomers</span>
                    </a>
                    <a href="GroomerControlador?accion=tiemposPromedio" class="btn btn-primary">
                        <span>⏱️ Tiempos Promedio</span>
                    </a>
                    <a href="GroomerControlador?accion=disponibilidad" class="btn btn-info">
                        <span>📅 Disponibilidad</span>
                    </a>
                    <a href="dashboard.jsp" class="btn btn-success">
                        <span>📊 Dashboard Principal</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script para manejar la interacción
        document.addEventListener('DOMContentLoaded', function() {
            // Establecer fecha por defecto si no está definida
            const fechaInput = document.getElementById('fecha');
            if (fechaInput && !fechaInput.value) {
                const hoy = new Date().toISOString().split('T')[0];
                fechaInput.value = hoy;
            }
            
            // Animación de carga progresiva para las filas
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    row.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Animación de barras de progreso
            const progressBars = document.querySelectorAll('.ocupacion-progress-bar');
            progressBars.forEach(bar => {
                const finalWidth = bar.style.width;
                bar.style.width = '0%';
                setTimeout(() => {
                    bar.style.transition = 'width 1.5s cubic-bezier(0.4, 0, 0.2, 1)';
                    bar.style.width = finalWidth;
                }, 500);
            });
        });

        // Función para establecer la fecha de hoy
        function establecerFechaHoy() {
            const hoy = new Date().toISOString().split('T')[0];
            document.getElementById('fecha').value = hoy;
            document.getElementById('filterForm').submit();
        }

        // Función para mostrar loading en botones
        function showLoading(button) {
            const originalText = button.innerHTML;
            button.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Procesando...';
            button.disabled = true;
            
            setTimeout(() => {
                button.innerHTML = originalText;
                button.disabled = false;
            }, 2000);
        }

        // Agregar evento de loading a los botones de navegación
        const navButtons = document.querySelectorAll('.navigation .btn, .header-actions .btn');
        navButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                if (this.href && !this.href.includes('javascript')) {
                    showLoading(this);
                }
            });
        });
    </script>
</body>
</html>

<%!
    // Método para obtener el nivel de ocupación
    private String obtenerNivelOcupacion(double porcentaje) {
        if (porcentaje <= 50) {
            return "ocupacion-baja";
        } else if (porcentaje <= 80) {
            return "ocupacion-media";
        } else {
            return "ocupacion-alta";
        }
    }

    // Método para obtener la clase CSS de ocupación
    private String obtenerClaseOcupacion(double porcentaje) {
        if (porcentaje <= 50) {
            return "ocupacion-optima";
        } else if (porcentaje <= 80) {
            return "ocupacion-moderada";
        } else {
            return "ocupacion-alta-badge";
        }
    }

    // Método para obtener el texto de ocupación
    private String obtenerTextoOcupacion(double porcentaje) {
        if (porcentaje <= 50) {
            return "Óptima";
        } else if (porcentaje <= 80) {
            return "Moderada";
        } else {
            return "Alta";
        }
    }

    // Método para obtener el color del porcentaje
    private String obtenerColorPorcentaje(double porcentaje) {
        if (porcentaje <= 50) {
            return "#28a745";
        } else if (porcentaje <= 80) {
            return "#ffc107";
        } else {
            return "#dc3545";
        }
    }
%>