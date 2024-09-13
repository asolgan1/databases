<!-- 
    Zachary Zhou: zzhou43
    Jamie Huang: jhuan131
    Alexey Solganik: asolgan1

    Given a country name, get a graph of that country's COVID data
-->

<?php
include 'open.php';
$country = $_POST['country'];
$caseDataPoints = array();
$deathDataPoints = array();

if ($stmt = $conn->prepare("CALL GetCovidData(?)")) {
    $stmt->bind_param("s", $country);

    if ($stmt->execute()) {
        $result = $stmt->get_result();
        if ($result->num_rows == 0) {
            echo "<div class=\"card\">";
            echo "<div class=\"card-body\">";
            echo "<p class=\"card-text\">No data found for " . $country . "</p>";
            echo "</div>";
            echo "</div>";
        } else {
            foreach ($result as $row) {
                array_push($caseDataPoints, array("x" => $row["month"], "y" => $row["cases"]));
                array_push($deathDataPoints, array("x" => $row["month"], "y" => $row["deaths"]));
            }
        }
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

<!DOCTYPE HTML>
<html>

<head>
    <script type="text/javascript">
        function convertDates(data) {
            return data.map(point => {
                return {
                    "x": new Date(point.x),
                    "y": point.y
                }
            })
        }

        window.onload = function() {
            var chartCases = new CanvasJS.Chart("chartContainer1", {
                title: {
                    text: "Covid Cases in " + <?php echo json_encode($country); ?>,
                    fontFamily: "arial"
                },

                axisX: {
                    title: "Time",
                    gridThickness: 2,
                    fontFamily: "arial"
                },

                axisY: {
                    title: "Cases",
                    fontFamily: "arial"
                },

                data: [{
                    type: "line",
                    fontFamily: "arial",
                    dataPoints: convertDates(<?php echo json_encode($caseDataPoints, JSON_NUMERIC_CHECK); ?>)
                }]
            })

            var chartDeaths = new CanvasJS.Chart("chartContainer2", {
                title: {
                    text: "Covid Deaths in " + <?php echo json_encode($country); ?>,
                    fontFamily: "arial"
                },

                axisX: {
                    title: "Time",
                    gridThickness: 2,
                    fontFamily: "arial"
                },

                axisY: {
                    title: "Cases",
                    fontFamily: "arial"
                },

                data: [{
                    type: "line",
                    fontFamily: "arial",
                    dataPoints: convertDates(<?php echo json_encode($deathDataPoints, JSON_NUMERIC_CHECK); ?>)
                }]
            })



            chartCases.render();
            chartDeaths.render();
        }
    </script>
    <script type="text/javascript" src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
</head>

<body>
    <div id="chartContainer1" style="height: 300px; width: 100%;">
    </div>
    <div id="chartContainer2" style="height: 300px; width: 100%;">
    </div>
    <a class="btn btn-link" href="zzhou43_jhuan131_asolgan1.html">Back</a>
</body>

</html>