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
    /// 库存预警设置
    /// </summary>
    internal class Sys_wh_warnConfiger : IEntityTypeConfiguration<Sys_wh_warn>
    {
        public void Configure(EntityTypeBuilder<Sys_wh_warn> builder)
        {
            builder.ToTable(nameof(Sys_wh_warn));
            builder.HasKey(e => e.warn_id);
            builder.Property(e => e.warn_day);
            builder.Property(e => e.notice_man).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.warn_time).HasColumnType("datetime").IsRequired();
        }
    }
}
