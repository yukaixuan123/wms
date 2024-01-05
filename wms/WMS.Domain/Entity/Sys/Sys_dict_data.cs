using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sys
{
    /// <summary>
    /// 字典数据表
    /// </summary>
    public class Sys_dict_data
    {
        //字典编码
        public int dict_code { get; set; }
        //字典排序
        public string dict_name { get; set; }
        //字典标签
        public string dict_label { get; set; }
        //字典类型
        public string dict_type { get; set; }
        //是否默认（y是n否）
        public string is_default { get; set; }
        //状态（0正常1停用）
        public string status {  get; set; }
        //字典键值
        public string dict_value {  get; set; }
        //操作人
        public string create_by { get; set; }
        //操作时间
        public DateTime create_time {  get; set; }
        //更新者
        public string update_by { get; set; }
        //更新时间
        public DateTime? update_time { get; set; }
        //备注
        public string remark { get; set; }

        //逻辑删除
        public string  is_del { get; set; }

        public int dict_id { get; set; }

    }
}
