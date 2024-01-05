using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using OfficeOpenXml;
using System.Text;
using WMS.Domain.Entity;

namespace WMS.Controllers.Cm
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExportController : ControllerBase
    {
        //[HttpPost]
        //public IActionResult ExportData([FromBody] PurchaseRecord rowData)
        //{
        //    // Process rowData and generate export data
        //    var csvData = GenerateCsvData(rowData);

        //    byte[] byteArray = Encoding.UTF8.GetBytes(csvData);
        //    var stream = new System.IO.MemoryStream(byteArray);

        //    return File(stream, "application/octet-stream", "exportedData.csv");
        //}

        //public int buy_codeId { get; set; }
        //public string buy_code { get; set; }
        //public DateTime buy_date { get; set; }
        //public string supply_code { get; set; }
        //public string link_man { get; set; }
        //public string link_way { get; set; }
        //public string buy_man { get; set; }
        //public string create_by { get; set; }
        //public DateTime create_time { get; set; }
        //public DateTime? update_time { get; set; }
        //public string update_by { get; set; }
        //public string sure_state { get; set; }
        //public string sure_man { get; set; }
        //public DateTime sure_date { get; set; }
        //public string remark { get; set; }
        //public string is_del { get; set; }
        //public string sale_state { get; set; }
        //public Decimal total_buy_num { get; set; }
        //public Decimal total_price { get; set; }
        //public string names { get; set; }

        //public string item_code { get; set; }

        //private string GenerateCsvData(PurchaseRecord rowData)
        //{
        //    // Implement logic to convert rowData to CSV format
        //    // Example: 
        //    var csvBuilder = new StringBuilder();
        //    csvBuilder.AppendLine("buy_codeId,buy_code,buy_date");
        //    csvBuilder.AppendLine($"{rowData.buy_codeId},{rowData.buy_code},{rowData.buy_date}");
        //    return csvBuilder.ToString();
        //}

        [HttpPost]
        public IActionResult ExportData([FromBody] PurchaseRecord[] tableData)
        {
            // Process tableData and generate export data
            var csvData = GenerateCsvData(tableData);

            byte[] byteArray = Encoding.UTF8.GetBytes(csvData);
            var stream = new System.IO.MemoryStream(byteArray);

            return File(stream, "application/octet-stream", "exportedData.csv");
        }

        private string GenerateCsvData(PurchaseRecord[] tableData)
        {
            // Implement logic to convert tableData to CSV format
            // Example: 
            var csvBuilder = new StringBuilder();
            csvBuilder.AppendLine("buy_codeId},buy_code,buy_date,sure_man,sure_state,update_by,buy_codeId,supply_code,link_man");

            //for (const row of tableData) {
            //    csvBuilder.AppendLine(`${row.Column1},${row.Column2},${row.Column3}`);
            //},{row.sure_man},{row.sure_state},{row.update_by}
            foreach (var row in tableData)
            {
                csvBuilder.AppendLine($"{row.buy_codeId},{ row.buy_code},{ row.buy_date},{row.sure_man},{row.sure_state},{row.update_by},{row.buy_codeId},{row.supply_code},{row.link_man}");
            }
            return csvBuilder.ToString();
        }



        //[HttpPost("Excel")]
        //public IActionResult ImportExcel(IFormFile file)
        //{
        //    using (var package = new ExcelPackage(file.OpenReadStream()))
        //    {
        //        // Access the Excel workbook and worksheet
        //        var workbook = package.Workbook;
        //        var worksheet = workbook.Worksheets[0];

        //        // Process the Excel data as needed
        //        // Example: Read data from Excel
        //        for (int row = worksheet.Dimension.Start.Row + 1; row <= worksheet.Dimension.End.Row; row++)
        //        {
        //            var cellValue = worksheet.Cells[row, 1].Text;
        //            // Process each cell value as needed
        //        }

        //        // Implement further logic to process the Excel data

        //        return Ok("Import successful");
        //    }
        //}

     
    }

}
