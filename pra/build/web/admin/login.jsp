<%@ page import="java.sql.*, com.hardware.utils.DBConnection" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Admin Login - Hardware Management</title>

    <!-- Font Awesome for icons -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>

        /* =========================
           GLOBAL
        ========================= */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {

            min-height: 100vh;

            display: flex;

            align-items: center;

            justify-content: center;

            font-family: Arial, Helvetica, sans-serif;

            color: #4d2630;

            background:
                radial-gradient(
                    circle at 15% 20%,
                    rgba(180, 135, 45, 0.13),
                    transparent 25%
                ),

                radial-gradient(
                    circle at 85% 75%,
                    rgba(180, 135, 45, 0.10),
                    transparent 25%
                ),

                #10090b;

            position: relative;

            overflow: hidden;
        }


        /* =========================
           BACKGROUND DECORATION
        ========================= */

        body::before {

            content: "";

            position: absolute;

            width: 500px;

            height: 500px;

            border: 1px solid rgba(193, 150, 62, 0.25);

            transform: rotate(45deg);

            top: -280px;

            left: -150px;
        }

        body::after {

            content: "";

            position: absolute;

            width: 500px;

            height: 500px;

            border: 1px solid rgba(193, 150, 62, 0.20);

            transform: rotate(45deg);

            bottom: -300px;

            right: -150px;
        }


        /* =========================
           LOGIN CARD
        ========================= */

        .login-card {

            position: relative;

            z-index: 2;

            width: 100%;

            max-width: 440px;

            padding: 42px 40px;

            background: #f1eee7;

            border: 2px solid #b9954c;

            border-radius: 20px;

            box-shadow:
                0 20px 55px rgba(0, 0, 0, 0.55),

                inset 0 0 25px rgba(
                    125,
                    91,
                    32,
                    0.06
                );
        }


        /* =========================
           TOP GOLD LINE
        ========================= */

        .gold-line {

            width: 70px;

            height: 4px;

            background: #bd963b;

            border-radius: 5px;

            margin: 0 auto 25px auto;
        }


        /* =========================
           LOGO
        ========================= */

        .logo {

            text-align: center;

            margin-bottom: 30px;
        }

        .logo-icon {

            width: 75px;

            height: 75px;

            margin: 0 auto 18px auto;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #651b36;

            border: 2px solid #c6a455;

            border-radius: 17px;

            box-shadow:
                0 8px 20px rgba(
                    101,
                    27,
                    54,
                    0.25
                );
        }

        .logo-icon i {

            font-size: 35px;

            color: #f1cf72;
        }


        /* =========================
           TITLE
        ========================= */

        .logo h2 {

            color: #651b36;

            font-size: 25px;

            font-weight: bold;

            margin-bottom: 7px;
        }

        .logo p {

            color: #806d62;

            font-size: 14px;

            margin: 0;
        }


        /* =========================
           ERROR MESSAGE
        ========================= */

        .error-message {

            background: #f5e2df;

            color: #722b31;

            padding: 12px 15px;

            border-radius: 9px;

            margin-bottom: 20px;

            display: none;

            border-left: 4px solid #8a263e;

            font-size: 13px;
        }

        .error-message.show {

            display: block;
        }

        .error-message i {

            margin-right: 6px;
        }


        /* =========================
           FORM
        ========================= */

        .form-group {

            margin-bottom: 20px;
        }

        .form-label {

            display: block;

            margin-bottom: 8px;

            color: #5d2c39;

            font-size: 14px;

            font-weight: bold;
        }


        /* =========================
           INPUT GROUP
        ========================= */

        .input-group {

            display: flex;

            width: 100%;

            border: 1px solid #c9b27b;

            border-radius: 9px;

            overflow: hidden;

            background: #fffaf0;

            transition: 0.25s;
        }

        .input-group:focus-within {

            border-color: #8a2345;

            box-shadow:
                0 0 0 3px rgba(
                    101,
                    27,
                    54,
                    0.12
                );
        }


        /* =========================
           ICON
        ========================= */

        .input-group-text {

            width: 48px;

            display: flex;

            align-items: center;

            justify-content: center;

            background: #f4ead9;

            color: #8c6b2f;

            border-right: 1px solid #d4bd85;

            flex-shrink: 0;
        }


        /* =========================
           INPUT
        ========================= */

        .form-control {

            width: 100%;

            border: none;

            outline: none;

            padding: 13px 14px;

            background: #fffaf0;

            color: #4d2630;

            font-size: 14px;
        }

        .form-control::placeholder {

            color: #9a8980;
        }

        .form-control:focus {

            outline: none;

            background: #fffdf8;
        }


        /* =========================
           LOGIN BUTTON
        ========================= */

        .btn-login {

            width: 100%;

            padding: 13px;

            margin-top: 5px;

            background: #651b36;

            color: white;

            border: 1px solid #7e2345;

            border-radius: 9px;

            font-size: 15px;

            font-weight: bold;

            cursor: pointer;

            transition: all 0.25s ease;
        }

        .btn-login:hover {

            background: #7b2345;

            transform: translateY(-2px);

            box-shadow:
                0 7px 18px rgba(
                    101,
                    27,
                    54,
                    0.30
                );
        }

        .btn-login i {

            color: #f1cf72;

            margin-right: 7px;
        }


        /* =========================
           DEFAULT LOGIN TEXT
        ========================= */

        .default-login {

            text-align: center;

            margin-top: 22px;

            padding-top: 18px;

            border-top: 1px solid #d8c9ad;

            color: #806d62;

            font-size: 12px;
        }

        .default-login strong {

            color: #651b36;
        }


        /* =========================
           BOTTOM DECORATION
        ========================= */

        .bottom-decoration {

            text-align: center;

            margin-top: 20px;

            color: #b08a38;

            font-size: 11px;

            letter-spacing: 1px;
        }


        /* =========================
           RESPONSIVE
        ========================= */

        @media (max-width: 500px) {

            .login-card {

                width: calc(100% - 30px);

                padding: 35px 25px;
            }

            .logo h2 {

                font-size: 21px;
            }

        }

    </style>

</head>


<body>


    <!-- =========================
         LOGIN CARD
    ========================== -->

    <div class="login-card">


        <!-- GOLD LINE -->

        <div class="gold-line"></div>


        <!-- LOGO -->

        <div class="logo">

            <div class="logo-icon">

                <i class="fas fa-tools"></i>

            </div>


            <h2>
                Hardware Management
            </h2>


            <p>
                Admin Panel Login
            </p>

        </div>


        <!-- ERROR -->

        <div class="error-message"
             id="errorMessage">

            <i class="fas fa-exclamation-circle"></i>

            Invalid username or password!

        </div>


        <!-- LOGIN FORM -->

        <form action="${pageContext.request.contextPath}/admin/login"
              method="POST">


            <!-- USERNAME -->

            <div class="form-group">

                <label class="form-label">

                    Username

                </label>


                <div class="input-group">

                    <span class="input-group-text">

                        <i class="fas fa-user"></i>

                    </span>


                    <input type="text"
                           name="username"
                           class="form-control"
                           placeholder="Enter username"
                           required>

                </div>

            </div>


            <!-- PASSWORD -->

            <div class="form-group">

                <label class="form-label">

                    Password

                </label>


                <div class="input-group">

                    <span class="input-group-text">

                        <i class="fas fa-lock"></i>

                    </span>


                    <input type="password"
                           name="password"
                           class="form-control"
                           placeholder="Enter password"
                           required>

                </div>

            </div>


            <!-- LOGIN BUTTON -->

            <button type="submit"
                    class="btn-login">

                <i class="fas fa-sign-in-alt"></i>

                Login

            </button>


        </form>


        <!-- DEFAULT LOGIN -->

        <div class="default-login">

            Default:
            <strong>admin</strong>
            /
            <strong>admin123</strong>

        </div>


        <!-- BOTTOM -->

        <div class="bottom-decoration">

            ? &nbsp; HARDWARE ADMINISTRATION &nbsp; ?

        </div>


    </div>


    <!-- ERROR SCRIPT -->

    <script>

        if (window.location.search.includes('error')) {

            document
                .getElementById('errorMessage')
                .classList
                .add('show');

        }

    </script>


</body>

</html>