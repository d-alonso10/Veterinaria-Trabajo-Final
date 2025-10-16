<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, modelo.ColaAtencionDTO" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cola de Atenciones - Sistema PetCare</title>
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
            --gradient-success: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            --gradient-warning: linear-gradient(135deg, #FFC107 0%, #ffb300 100%);
            --gradient-danger: linear-gradient(135deg, #F44336 0%, #d32f2f 100%);
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

        /* Sidebar Styles - Manteniendo el diseño del dashboard */
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

        /* Botones - Usando el mismo estilo del dashboard */
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

        .btn-danger {
            background: var(--gradient-danger);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(244, 67, 54, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(244, 67, 54, 0.4);
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

        .btn-info {
            background: var(--gradient-info);
            color: var(--white);
            box-shadow: 0 8px 25px rgba(33, 150, 243, 0.3);
        }

        .btn-info:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(33, 150, 243, 0.4);
        }

        .btn-small {
            padding: 12px 20px;
            font-size: 0.85em;
        }

        /* Mensajes de estado - Mejorados */
        .mensaje {
            padding: 20px 25px;
            margin: 0 0 30px 0;
            border-radius: var(--radius);
            font-size: 1em;
            box-shadow: var(--shadow);
            border-left: 4px solid;
            animation: fadeInUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .mensaje::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .mensaje:hover::before {
            opacity: 1;
        }

        .exito {
            background-color: #f0f9f4;
            border-left-color: var(--success-color);
            color: #1e7e34;
        }

        .error {
            background-color: #fdf2f2;
            border-left-color: var(--danger-color);
            color: #c53030;
        }

        .info {
            background-color: #f0f7ff;
            border-left-color: var(--info-color);
            color: var(--text-dark);
        }

        /* Action Buttons - Mejorados */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        /* Filter Buttons - Mejorados */
        .filter-buttons {
            background: var(--white);
            padding: 25px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-bottom: 30px;
            border-top: 4px solid var(--info-color);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .filter-buttons::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-info);
        }

        .filter-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            color: var(--text-dark);
        }

        .filter-icon {
            font-size: 1.5em;
            color: var(--info-color);
        }

        .filter-title {
            font-size: 1.2em;
            font-weight: 600;
        }

        .filter-options {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        /* Stats Card - Mejorado */
        .stats-card {
            background: var(--white);
            padding: 30px;
            border-radius: var(--radius);
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            border-left: 4px solid var(--primary-color);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.6s ease-out;
        }

        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .stats-icon {
            font-size: 2.5em;
            color: var(--primary-color);
        }

        .stats-content h3 {
            color: var(--text-dark);
            margin-bottom: 10px;
            font-size: 1.4em;
            font-weight: 700;
        }

        .stats-content p {
            color: var(--text-light);
            font-size: 1em;
            line-height: 1.6;
        }

        /* Table Container - Mejorado */
        .table-container {
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
            border: 1px solid rgba(0, 0, 0, 0.05);
            position: relative;
            animation: fadeInUp 0.6s ease-out;
        }

        .table-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        table {
            width: 100%;
            border-collapse: collapse;
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
        }

        td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        tr:hover td {
            background-color: rgba(171, 203, 213, 0.05);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        /* Status Badges - Mejorados */
        .status-badge {
            padding: 10px 16px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .status-pendiente {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .status-proceso {
            background: #cce7ff;
            color: #004085;
            border: 1px solid #b3d7ff;
        }

        .status-completada {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-cancelada {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .turno-badge {
            background: var(--primary-light);
            color: var(--text-dark);
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 1em;
            border: 2px solid var(--primary-color);
            transition: all 0.3s ease;
        }

        .turno-badge:hover {
            background: var(--primary-color);
            color: var(--white);
            transform: scale(1.05);
        }

        /* Custom Checkbox Styles - Mejorados */
        .customCheckBoxHolder {
            margin: 8px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            gap: 4px;
        }

        .customCheckBox {
            width: 100%;
            position: relative;
            overflow: hidden;
            cursor: pointer;
            user-select: none;
            padding: 10px 12px;
            border-radius: var(--radius);
            font-weight: 600;
            font-size: 0.8em;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            height: 36px;
            align-items: center;
            justify-content: center;
            outline: none;
            min-width: 70px;
            border: 2px solid transparent;
        }

        .customCheckBox:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .customCheckBox .inner {
            pointer-events: none;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .customCheckBox:hover .inner {
            transform: translateY(-1px);
        }

        .customCheckBoxWrapper {
            width: 100%;
        }

        .customCheckBoxInput {
            display: none;
        }

        .customCheckBoxInput:checked + .customCheckBoxWrapper .customCheckBox {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.2);
        }

        /* Estados específicos para los checkboxes - Mejorados */
        .estado-pendiente-cb .customCheckBox { 
            background-color: #fff3cd; 
            color: #856404; 
            border-color: #ffeaa7;
        }
        .estado-proceso-cb .customCheckBox { 
            background-color: #cce7ff; 
            color: #004085; 
            border-color: #b3d7ff;
        }
        .estado-completada-cb .customCheckBox { 
            background-color: #d4edda; 
            color: #155724; 
            border-color: #c3e6cb;
        }
        .estado-cancelada-cb .customCheckBox { 
            background-color: #f8d7da; 
            color: #721c24; 
            border-color: #f5c6cb;
        }

        .estado-pendiente-cb .customCheckBox:hover { 
            background-color: #ffeaa7; 
            color: #856404; 
        }
        .estado-proceso-cb .customCheckBox:hover { 
            background-color: #b3d7ff; 
            color: #004085; 
        }
        .estado-completada-cb .customCheckBox:hover { 
            background-color: #c3e6cb; 
            color: #155724; 
        }
        .estado-cancelada-cb .customCheckBox:hover { 
            background-color: #f5c6cb; 
            color: #721c24; 
        }

        .estado-pendiente-cb .customCheckBoxInput:checked + .customCheckBoxWrapper .customCheckBox { 
            background-color: #ffc107; 
            color: #000; 
            border-color: #ffc107;
        }
        .estado-proceso-cb .customCheckBoxInput:checked + .customCheckBoxWrapper .customCheckBox { 
            background-color: #17a2b8; 
            color: #fff; 
            border-color: #17a2b8;
        }
        .estado-completada-cb .customCheckBoxInput:checked + .customCheckBoxWrapper .customCheckBox { 
            background-color: #28a745; 
            color: #fff; 
            border-color: #28a745;
        }
        .estado-cancelada-cb .customCheckBoxInput:checked + .customCheckBoxWrapper .customCheckBox { 
            background-color: #dc3545; 
            color: #fff; 
            border-color: #dc3545;
        }

        /* Action Forms - Mejorados */
        .action-form {
            display: flex;
            flex-direction: column;
            gap: 12px;
            padding: 15px;
            background: rgba(171, 203, 213, 0.05);
            border-radius: var(--radius);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .action-buttons-table {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn-action {
            padding: 10px 16px;
            font-size: 0.85em;
            border-radius: 10px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 500;
            position: relative;
            overflow: hidden;
        }

        .btn-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s;
        }

        .btn-action:hover::before {
            left: 100%;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        /* Empty State - Mejorado */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            color: var(--text-light);
            background: var(--white);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            animation: fadeInUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .empty-state::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
        }

        .empty-state h3 {
            font-size: 1.8em;
            margin-bottom: 20px;
            color: var(--text-dark);
            font-weight: 700;
        }

        .empty-state p {
            font-size: 1.1em;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        /* Navigation - Mejorado */
        .navigation {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }

        /* Animation Effects */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(40px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        .floating {
            animation: floating 3s ease-in-out infinite;
        }

        @keyframes floating {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
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
            .action-buttons {
                flex-direction: column;
            }
            .filter-options {
                flex-direction: column;
            }
            .table-container {
                overflow-x: auto;
            }
            table {
                min-width: 800px;
            }
            .navigation {
                flex-direction: column;
                align-items: center;
            }
            .btn {
                width: 100%;
                justify-content: center;
            }
            .action-buttons-table {
                flex-direction: column;
                gap: 8px;
            }
            .stats-card {
                flex-direction: column;
                text-align: center;
            }
            .customCheckBoxHolder {
                flex-direction: row;
                flex-wrap: wrap;
            }
            .customCheckBox {
                flex: 1;
                min-width: 120px;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 20px;
            }
            .main-content {
                padding: 15px;
            }
        }

        .no-data {
            color: var(--text-light);
            font-style: italic;
        }

        /* Loading animation */
        .loading-dots {
            display: inline-flex;
            gap: 4px;
        }

        .loading-dots span {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: currentColor;
            animation: loading 1.4s infinite ease-in-out;
        }

        .loading-dots span:nth-child(1) { animation-delay: -0.32s; }
        .loading-dots span:nth-child(2) { animation-delay: -0.16s; }

        @keyframes loading {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar Menu - Actualizado para coincidir con el dashboard -->
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
                <div class="menu-section">Núcleo del Negocio</div>
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
                <li class="menu-item active">
                    <a href="AtencionControlador">
                        <span class="menu-icon">🎯</span>
                        <span>Atención</span>
                    </a>
                </li>
                
                <!-- Gestión de Clientes -->
                <div class="menu-section">Gestión de Clientes</div>
                <li class="menu-item">
                    <a href="Clientes.jsp">
                        <span class="menu-icon">👥</span>
                        <span>Clientes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="ListaMascotas.jsp">
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
                <li class="menu-item">
                    <a href="ClienteControlador?accion=listarFrecuentes">
                        <span class="menu-icon">🏆</span>
                        <span>Clientes Frecuentes</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="BuscarClientes.jsp">
                        <span class="menu-icon">🔍</span>
                        <span>Búsqueda Avanzada</span>
                    </a>
                </li>
                
                <!-- Personal y Operaciones -->
                <div class="menu-section">Personal y Operaciones</div>
                <li class="menu-item">
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
                <div class="menu-section">Finanzas</div>
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
                <div class="menu-section">Análisis y Control</div>
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
                <div class="menu-section">Sistema</div>
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
                        <h1>📋 Cola de Atenciones</h1>
                        <p>Gestión en tiempo real de las atenciones programadas - <%= new java.text.SimpleDateFormat("EEEE, d 'de' MMMM 'de' yyyy").format(new java.util.Date()) %></p>
                    </div>
                    <div class="header-actions">
                        <a href="AtencionControlador?accion=formularioWalkIn" class="btn btn-success">➕ Nueva Atención Walk-in</a>
                        <a href="AtencionControlador" class="btn btn-info">🔄 Actualizar Cola</a>
                    </div>
                </div>
            </div>

            <div class="main-content">
                <!-- Mensajes -->
                <% if (request.getAttribute("mensaje") != null) { %>
                    <div class="mensaje <%= request.getAttribute("mensaje").toString().contains("✅") ? "exito" : "error" %>">
                        <%= request.getAttribute("mensaje") %>
                    </div>
                <% } %>

                <!-- Botones de acciones principales -->
                <div class="action-buttons">
                    <a href="AtencionControlador?accion=formularioWalkIn" class="btn btn-success">➕ Nueva Atención Walk-in</a>
                    <a href="AtencionControlador" class="btn btn-info">🔄 Actualizar Cola</a>
                    <a href="CitaControlador?accion=todasCitas" class="btn btn-primary">📅 Ver Todas las Citas</a>
                </div>

                <!-- Filtros por sucursal -->
                <div class="filter-buttons">
                    <div class="filter-header">
                        <span class="filter-icon">🏢</span>
                        <span class="filter-title">Filtrar por Sucursal:</span>
                    </div>
                    <div class="filter-options">
                        <a href="AtencionControlador" class="btn btn-info btn-small">🏠 Todas las Sucursales</a>
                        <a href="AtencionControlador?accion=colaActual&idSucursal=1" class="btn btn-info btn-small">🏢 Sucursal 1</a>
                        <a href="AtencionControlador?accion=colaActual&idSucursal=2" class="btn btn-info btn-small">🏢 Sucursal 2</a>
                        <a href="AtencionControlador?accion=colaActual&idSucursal=3" class="btn btn-info btn-small">🏢 Sucursal 3</a>
                    </div>
                </div>

                <%
                    List<ColaAtencionDTO> colaAtenciones = (List<ColaAtencionDTO>) request.getAttribute("colaAtenciones");
                    Integer totalAtenciones = (Integer) request.getAttribute("totalAtenciones");
                    Integer idSucursal = (Integer) request.getAttribute("idSucursal");
                %>

                <!-- Estadísticas -->
                <div class="stats-card floating">
                    <div class="stats-icon">📊</div>
                    <div class="stats-content">
                        <h3>Resumen de la Cola</h3>
                        <p>
                            <strong>Total de atenciones en cola:</strong> <%= totalAtenciones != null ? totalAtenciones : 0 %>
                            <% if (idSucursal != null) { %>
                                - <strong>Sucursal <%= idSucursal %></strong>
                            <% } %>
                        </p>
                        <p><em>Gestión en tiempo real del flujo de atenciones</em></p>
                    </div>
                </div>

                <!-- Tabla de cola de atenciones -->
                <% if (colaAtenciones != null && !colaAtenciones.isEmpty()) { %>
                    <div class="table-container">
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width: 80px;">Turno</th>
                                        <th>Mascota</th>
                                        <th>Cliente</th>
                                        <th>Groomer</th>
                                        <th style="width: 120px;">Estado</th>
                                        <th style="width: 150px;">Inicio Estimado</th>
                                        <th style="width: 150px;">Fin Estimado</th>
                                        <th style="width: 200px;">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (ColaAtencionDTO atencion : colaAtenciones) { 
                                        String claseEstado = "";
                                        String estadoDisplay = "";
                                        String iconoEstado = "";
                                        switch(atencion.getEstado().toLowerCase()) {
                                            case "pendiente": 
                                                claseEstado = "status-pendiente"; 
                                                estadoDisplay = "PENDIENTE";
                                                iconoEstado = "⏳";
                                                break;
                                            case "en_proceso": 
                                                claseEstado = "status-proceso"; 
                                                estadoDisplay = "EN PROCESO";
                                                iconoEstado = "🔄";
                                                break;
                                            case "completada": 
                                                claseEstado = "status-completada"; 
                                                estadoDisplay = "COMPLETADA";
                                                iconoEstado = "✅";
                                                break;
                                            case "cancelada": 
                                                claseEstado = "status-cancelada"; 
                                                estadoDisplay = "CANCELADA";
                                                iconoEstado = "❌";
                                                break;
                                            default:
                                                claseEstado = "status-pendiente";
                                                estadoDisplay = atencion.getEstado().toUpperCase();
                                                iconoEstado = "⚪";
                                        }
                                    %>
                                        <tr>
                                            <td>
                                                <span class="turno-badge">#<%= atencion.getTurnoNum() %></span>
                                            </td>
                                            <td>
                                                <strong>🐕 <%= atencion.getMascota() %></strong>
                                            </td>
                                            <td>
                                                <strong>👤 <%= atencion.getCliente() %></strong>
                                            </td>
                                            <td>
                                                <strong>✂️ <%= atencion.getGroomer() %></strong>
                                            </td>
                                            <td>
                                                <span class="status-badge <%= claseEstado %>">
                                                    <%= iconoEstado %> <%= estadoDisplay %>
                                                </span>
                                            </td>
                                            <td>
                                                <% if (atencion.getTiempoEstimadoInicio() != null) { %>
                                                    <strong><%= atencion.getTiempoEstimadoInicio() %></strong>
                                                <% } else { %>
                                                    <span class="no-data">No definido</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <% if (atencion.getTiempoEstimadoFin() != null) { %>
                                                    <strong><%= atencion.getTiempoEstimadoFin() %></strong>
                                                <% } else { %>
                                                    <span class="no-data">No definido</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <!-- Formulario con checkboxes personalizados para actualizar estado -->
                                                <form action="AtencionControlador" method="POST" class="action-form">
                                                    <input type="hidden" name="accion" value="actualizarEstado">
                                                    <input type="hidden" name="idAtencion" value="<%= atencion.getIdAtencion() %>">
                                                    
                                                    <div class="customCheckBoxHolder">
                                                        <input class="customCheckBoxInput" id="cCB1_<%= atencion.getIdAtencion() %>" type="radio" name="nuevoEstado" value="pendiente" <%= "pendiente".equals(atencion.getEstado().toLowerCase()) ? "checked" : "" %> />
                                                        <label class="customCheckBoxWrapper estado-pendiente-cb" for="cCB1_<%= atencion.getIdAtencion() %>">
                                                            <div class="customCheckBox">
                                                                <div class="inner">⏳ Pendiente</div>
                                                            </div>
                                                        </label>

                                                        <input class="customCheckBoxInput" id="cCB2_<%= atencion.getIdAtencion() %>" type="radio" name="nuevoEstado" value="en_proceso" <%= "en_proceso".equals(atencion.getEstado().toLowerCase()) ? "checked" : "" %> />
                                                        <label class="customCheckBoxWrapper estado-proceso-cb" for="cCB2_<%= atencion.getIdAtencion() %>">
                                                            <div class="customCheckBox">
                                                                <div class="inner">🔄 En Proceso</div>
                                                            </div>
                                                        </label>

                                                        <input class="customCheckBoxInput" id="cCB3_<%= atencion.getIdAtencion() %>" type="radio" name="nuevoEstado" value="completada" <%= "completada".equals(atencion.getEstado().toLowerCase()) ? "checked" : "" %> />
                                                        <label class="customCheckBoxWrapper estado-completada-cb" for="cCB3_<%= atencion.getIdAtencion() %>">
                                                            <div class="customCheckBox">
                                                                <div class="inner">✅ Completada</div>
                                                            </div>
                                                        </label>

                                                        <input class="customCheckBoxInput" id="cCB4_<%= atencion.getIdAtencion() %>" type="radio" name="nuevoEstado" value="cancelada" <%= "cancelada".equals(atencion.getEstado().toLowerCase()) ? "checked" : "" %> />
                                                        <label class="customCheckBoxWrapper estado-cancelada-cb" for="cCB4_<%= atencion.getIdAtencion() %>">
                                                            <div class="customCheckBox">
                                                                <div class="inner">❌ Cancelada</div>
                                                            </div>
                                                        </label>
                                                    </div>
                                                    
                                                    <button type="submit" class="btn btn-warning btn-small" style="width: 100%;">
                                                        🔄 Actualizar Estado
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } else { %>
                    <div class="empty-state">
                        <h3>📋 No hay atenciones en cola</h3>
                        <p>
                            <% if (idSucursal != null) { %>
                                No hay atenciones programadas para la sucursal <%= idSucursal %> en este momento.
                            <% } else { %>
                                No hay atenciones programadas en el sistema en este momento.
                            <% } %>
                        </p>
                        <a href="AtencionControlador?accion=formularioWalkIn" class="btn btn-success">➕ Crear Primera Atención</a>
                    </div>
                <% } %>

                <!-- Navegación -->
                <div class="navigation">
                    <a href="AtencionControlador" class="btn btn-info">🔄 Actualizar Cola</a>
                    <a href="AtencionControlador?accion=formularioWalkIn" class="btn btn-success">➕ Nueva Atención Walk-in</a>
                    <a href="CitaControlador?accion=todasCitas" class="btn btn-primary">📅 Gestión de Citas</a>
                    <a href="dashboard.jsp" class="btn btn-secondary">📊 Ir al Dashboard</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Script para manejar la interacción del menú
        document.addEventListener('DOMContentLoaded', function() {
            const menuItems = document.querySelectorAll('.menu-item');
            
            menuItems.forEach(item => {
                item.addEventListener('click', function() {
                    // Remover clase active de todos los items
                    menuItems.forEach(i => i.classList.remove('active'));
                    // Agregar clase active al item clickeado
                    this.classList.add('active');
                });
            });
            
            // Agregar efectos hover a los botones de acción
            const actionButtons = document.querySelectorAll('.btn-action');
            actionButtons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px) scale(1.05)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Confirmación antes de cambiar estado
            const forms = document.querySelectorAll('.action-form');
            forms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const idAtencion = this.querySelector('input[name="idAtencion"]').value;
                    const selectedOption = this.querySelector('input[name="nuevoEstado"]:checked');
                    
                    if (!selectedOption) {
                        e.preventDefault();
                        alert('⚠️ Por favor seleccione un estado para la atención.');
                        return false;
                    }
                    
                    const nuevoEstado = selectedOption.parentElement.querySelector('.inner').textContent;
                    
                    if (!confirm(`¿Está seguro de cambiar el estado de la atención #${idAtencion} a: ${nuevoEstado}?`)) {
                        e.preventDefault();
                        return false;
                    } else {
                        // Mostrar loading en el botón de enviar
                        const submitBtn = this.querySelector('button[type="submit"]');
                        const originalText = submitBtn.innerHTML;
                        submitBtn.innerHTML = '<span class="loading-dots"><span></span><span></span><span></span></span> Actualizando...';
                        submitBtn.disabled = true;
                    }
                });
            });

            // Auto-submit al seleccionar un checkbox (opcional)
            const checkboxes = document.querySelectorAll('.customCheckBoxInput');
            checkboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    // Opcional: auto-submit al cambiar estado
                    // this.form.submit();
                });
            });

            // Agregar animaciones a las filas de la tabla
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    row.style.transition = 'all 0.4s ease';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
                }, index * 50);
            });

            // Animaciones de entrada para elementos
            const animatedElements = document.querySelectorAll('.action-buttons, .filter-buttons, .stats-card, .table-container, .empty-state');
            animatedElements.forEach((element, index) => {
                if (element) {
                    element.style.opacity = '0';
                    element.style.transform = 'translateY(30px)';
                    
                    setTimeout(() => {
                        element.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                        element.style.opacity = '1';
                        element.style.transform = 'translateY(0)';
                    }, index * 100);
                }
            });

            // Efecto hover para botones principales
            const buttons = document.querySelectorAll('.btn');
            buttons.forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-3px)';
                });
                button.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
        });

        // Función para filtrar por estado
        function filtrarPorEstado(estado) {
            const rows = document.querySelectorAll('tbody tr');
            rows.forEach(row => {
                const statusBadge = row.querySelector('.status-badge');
                if (estado === 'todos') {
                    row.style.display = '';
                } else if (statusBadge.textContent.toLowerCase().includes(estado)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // Agregar filtros si hay datos
        <% if (colaAtenciones != null && !colaAtenciones.isEmpty()) { %>
        document.addEventListener('DOMContentLoaded', function() {
            const tableContainer = document.querySelector('.table-container');
            const filterDiv = document.createElement('div');
            filterDiv.style.marginBottom = '15px';
            filterDiv.style.display = 'flex';
            filterDiv.style.gap = '10px';
            filterDiv.style.alignItems = 'center';
            filterDiv.style.flexWrap = 'wrap';
            filterDiv.innerHTML = `
                <strong>Filtrar por estado:</strong>
                <button onclick="filtrarPorEstado('todos')" class="btn btn-small">Todos</button>
                <button onclick="filtrarPorEstado('pendiente')" class="btn btn-small">⏳ Pendientes</button>
                <button onclick="filtrarPorEstado('proceso')" class="btn btn-small">🔄 En Proceso</button>
                <button onclick="filtrarPorEstado('completada')" class="btn btn-small">✅ Completadas</button>
                <button onclick="filtrarPorEstado('cancelada')" class="btn btn-small">❌ Canceladas</button>
            `;
            tableContainer.parentNode.insertBefore(filterDiv, tableContainer);
        });
        <% } %>

        // Función para actualizar automáticamente la cola cada 30 segundos
        function autoActualizarCola() {
            setTimeout(() => {
                window.location.reload();
            }, 30000); // 30 segundos
        }

        // Iniciar auto-actualización si hay atenciones en cola
        <% if (colaAtenciones != null && !colaAtenciones.isEmpty()) { %>
        document.addEventListener('DOMContentLoaded', function() {
            autoActualizarCola();
            
            // Mostrar notificación de auto-actualización
            const notification = document.createElement('div');
            notification.className = 'mensaje info';
            notification.innerHTML = '🔄 <strong>Actualización automática:</strong> La cola se actualizará automáticamente cada 30 segundos.';
            document.querySelector('.main-content').insertBefore(notification, document.querySelector('.action-buttons'));
            
            setTimeout(() => {
                notification.style.opacity = '0';
                setTimeout(() => notification.remove(), 500);
            }, 5000);
        });
        <% } %>
    </script>
</body>
</html>