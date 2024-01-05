using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Sys;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 字典数据表
    /// </summary>
    internal class Sys_dict_dataConfiger : IEntityTypeConfiguration<Sys_dict_data>
    {
        public void Configure(EntityTypeBuilder<Sys_dict_data> builder)
        {
            builder.ToTable(nameof(Sys_dict_data));
            builder.HasKey(e => e.dict_code);
            builder.Property(e => e.dict_name).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.dict_label).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.dict_type).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.is_default).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.status).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.dict_value).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.update_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.update_time).HasColumnType("datetime");
            builder.Property(e => e.remark).HasMaxLength(64).IsUnicode(false).IsRequired(false);
        }
    }
}
