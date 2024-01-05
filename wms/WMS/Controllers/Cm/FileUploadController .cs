using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;

using IHostingEnvironment = Microsoft.AspNetCore.Hosting.IHostingEnvironment;

namespace WMS.Controllers.Cm
{
    [Route("api/[controller]/[action]")]
    [ApiController]

    public class FileUploadController : Controller
    {
        private static IHostingEnvironment _hostingEnvironment;

        public FileUploadController(IHostingEnvironment hostingEnvironment)
        {
            _hostingEnvironment = hostingEnvironment;
        }
        /// <summary>
        ///  多文件上传
        /// </summary>
        /// <param name="formCollection">表单集合值</param>
        /// <returns>服务器存储的文件信息</returns>

        //[HttpPost]
        [HttpPost]

        
        public IActionResult Upload(List<IFormFile> files)
        {
            foreach (var file in files)
            {
                if (file.Length > 0)
                {
                    // 处理每个上传的文件，例如保存到服务器

                    // 示例保存到 wwwroot/uploads 目录下
                    var filePath = Path.Combine(Directory.GetCurrentDirectory(), "Uploads", file.FileName);

                    using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        file.CopyTo(stream);
                    }
                }
            }

            return Ok("图片上传成功！！！");
        }
        /*

                [HttpPost("Upload")]
                public async Task<IActionResult> Upload1(IFormFile files)
                {
                    var urls = new List<string>();

                  //  foreach (var file in files)
               //     {
                        // 处理上传的每个文件，保存到服务器的指定目录下
                        var filePath = Path.Combine(Directory.GetCurrentDirectory(), "Uploads", files.FileName);
                        using (var stream = new FileStream(filePath, FileMode.Create))
                        {
                            await files.CopyToAsync(stream);
                        }

                        urls.Add(filePath);


                    return Ok(new { urls = urls }); // 返回文件的保存路径数组
                }*/
        [HttpPost("Upload")]
        public IActionResult UploadFile(IFormFile file)
        {
            try
            {
                // 文件上传逻辑
                if (file == null || file.Length == 0)
                    return BadRequest("No file uploaded.");

                var path = Path.Combine(Directory.GetCurrentDirectory(), "uploads", file.FileName);
                using (var stream = new FileStream(path, FileMode.Create))
                {
                    file.CopyTo(stream);
                }
                return Ok("File uploaded successfully.");
            }
            catch (Exception ex)
            {
                // 处理异常，可以记录日志或返回适当的错误响应
                return StatusCode(500, $"Internal Server Error: {ex.Message}");
            }
        }


       
    }
}
