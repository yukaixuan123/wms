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
    /// 数据字典主表
    /// </summary>
    internal class Sys_dict_typeConfiger : IEntityTypeConfiguration<Sys_dict_type>
    {
        public void Configure(EntityTypeBuilder<Sys_dict_type> builder)
        {
            builder.ToTable(nameof(Sys_dict_type));
            builder.HasKey(e => e.dict_id);
            builder.Property(e => e.dict_name).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.dict_label).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.dict_value).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.update_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.update_time).HasColumnType("datetime");
            builder.Property(e => e.remark).HasMaxLength(500).IsUnicode(false).IsRequired(false);
        }
    }
}
