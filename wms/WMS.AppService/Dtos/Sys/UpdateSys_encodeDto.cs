using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.AppService.Dtos.Sys
{
    public class UpdateSys_encodeDto
    {
        public int en_code { get; set; }
        //目标表单
        public string en_form { get; set; }
        //标号前缀
        public string en_prefix { get; set; }
        //时间规则
        public string en_time { get; set; }
        //流水号/位
        public int en_num { get; set; }
        //步长
        public int en_step { get; set; }
        //编号生成规则
        public string en_rules { get; set; }
        //操作人
        public string create_by { get; set; }
        //操作时间
        public DateTime create_time { get; set; }

        public string is_del { get; set; }


    }
}
