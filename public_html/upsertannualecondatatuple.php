<!-- 
    Zachary Zhou: zzhou43
    Jamie Huang: jhuan131
    Alexey Solganik: asolgan1

    Upsert an annual econ data tuple
-->

<head>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>


<body>
    <!-- Set up scripts for Bootstrap CDN  -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>


    <?php
    include 'open.php';
    $name = $_POST['name'];
    $year = $_POST['year'];
    $unemploymentRate = $_POST['unemploymentRate'] ? $_POST['unemploymentRate'] : NULL;
    $netLB = $_POST['netLB'] ? $_POST['netLB'] : NULL;
    $cpi = $_POST['cpi'] ? $_POST['cpi'] : NULL;
    $gdp = $_POST['gdp'] ? $_POST['gdp'] : NULL;

    if ($stmt = $conn->prepare("CALL UpsertAnnualEconDataTuple(?, ?, ?, ?, ?, ?)")) {
        $stmt->bind_param("sidddd", $name, $year, $unemploymentRate, $netLB, $cpi, $gdp);

        if ($stmt->execute()) {
            $result = $stmt->get_result();
            $row = $result->fetch_row();
            echo "<div class=\"card\">";
            echo "<div class=\"card-body\">";
            echo "<h5 class=\"card-title\">" . $row[0] . "</h5>";
            if ($stmt->field_count > 1) {
                echo "<h6 class=\"card-subtitle\" mb-2>" . $row[1] . " " . $row[2] . "</h6>";
                echo "<p class=\"card-text\">Unemployment Rate: " . $row[3] . "</p>";
                echo "<p class=\"card-text\">Net Gov Lending/Borrowing: " . $row[4] . "</p>";
                echo "<p class=\"card-text\">Consumer Price Index: " . $row[5] . "</p>";
                echo "<p class=\"card-text\">Gross Domestic Product: " . $row[6] . "</p>";
            }
            echo "<a href=\"modifydata.html\" class=\"card-link\">Back</a>";
            echo "</div>";
            echo "</div>";
            $result->free_result();
        } else {
            echo "Execute failed";
        }

        $stmt->close();
    } else {
        echo "Prepared statment failed";
    }

    $conn->close();
    ?>
</body>